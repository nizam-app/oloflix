// features/profile/data/profile_data_update.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Oloflix/core/constants/api_control/auth_api.dart';

class ProfileUpdateController extends StateNotifier<AsyncValue<void>> {
  ProfileUpdateController() : super(const AsyncData(null));

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? userAddress,
    File? userImage,
  }) async {
    final nothingToUpdate =
        (name?.trim().isEmpty ?? true) &&
            (phone?.trim().isEmpty ?? true) &&
            (userAddress?.trim().isEmpty ?? true) &&
            userImage == null;
    if (nothingToUpdate) throw Exception('Nothing to update');

    state = const AsyncLoading();
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('token');
      if (token == null || token.isEmpty) throw Exception('Token not found');

      final req = http.MultipartRequest('POST', Uri.parse(AuthAPIController.profile))
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token';

      void put(String k, String? v) {
        final x = v?.trim();
        if (x != null && x.isNotEmpty) req.fields[k] = x;
      }

      put('name', name);
      put('phone', phone);
      put('user_address', userAddress); // <-- API key

      if (userImage != null) {
        // ✅ normalize to JPEG + compress to <=1.2MB
        final prepared = await _prepareForUpload(userImage, maxKB: 1200);
        final bytes = await prepared.readAsBytes();
        final mime = lookupMimeType(prepared.path) ?? 'image/jpeg';
        req.files.add(http.MultipartFile.fromBytes(
          'user_image',                                        // <-- server key
          bytes,
          filename: p.basename(prepared.path),
          contentType: MediaType.parse(mime),
        ));
      }

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode ~/ 100 != 2) {
        // show backend validation reason (422 etc.)
        try {
          final body = jsonDecode(res.body);
          String msg = 'Failed (${res.statusCode})';
          if (body is Map) {
            if (body['errors'] is Map && (body['errors'] as Map).isNotEmpty) {
              final first = (body['errors'] as Map).values.first;
              msg = first is List ? first.join(', ') : first.toString();
            } else if (body['message'] != null) {
              msg = body['message'].toString();
            }
          }
          throw Exception(msg);
        } catch (_) {
          throw Exception('Failed (${res.statusCode}): ${res.body}');
        }
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Convert HEIC/HEIF → JPEG and compress to <= maxKB.
  Future<File> _prepareForUpload(File src, {int maxKB = 1200}) async {
    // 1) ensure JPEG
    final File jpeg = await _ensureJpeg(src);

    // 2) compress (quality & downscale) until <= maxKB
    final dir = await getTemporaryDirectory();
    String outPath() => p.join(dir.path, 'up_${DateTime.now().millisecondsSinceEpoch}.jpg');

    int quality = 90;
    int longSide = 2048;
    File current = jpeg;

    Future<File> _compress() async {
      final result = await FlutterImageCompress.compressAndGetFile(
        current.path,
        outPath(),
        format: CompressFormat.jpeg,
        quality: quality,
        minWidth: longSide,
        minHeight: longSide,
      );
      return File(result?.path ?? current.path);
    }

    File out = await _compress();
    while ((await out.length()) > maxKB * 1024) {
      if (quality > 60) {
        quality -= 10;
      } else if (longSide > 1080) {
        longSide -= 256;
        quality = 80;
      } else {
        // can't reduce more—break to avoid infinite loop
        break;
      }
      out = await _compress();
    }
    return out;
  }

  /// If camera produced HEIC/HEIF, convert to JPEG so server accepts it.
  Future<File> _ensureJpeg(File file) async {
    final mime = (lookupMimeType(file.path) ?? '').toLowerCase();
    final isHeic = mime.contains('heic') || mime.contains('heif') ||
        file.path.toLowerCase().endsWith('.heic') ||
        file.path.toLowerCase().endsWith('.heif');

    if (!isHeic) return file;

    final dir = await getTemporaryDirectory();
    final outPath = p.join(dir.path, 'cam_${DateTime.now().millisecondsSinceEpoch}.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      format: CompressFormat.jpeg,
      quality: 92,
    );
    return File(result?.path ?? file.path);
  }
}