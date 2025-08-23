// Flutter imports:
import 'dart:io';
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/features/profile/data/profile_data_update.dart';
import 'package:Oloflix/features/profile/logic/profile_data_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  static final routeName = '/profileScreen';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  void clear (){
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
  }

  File? _pickedImage;
  bool _isInitialized = false; // 🔑 যোগ করা হলো

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(ProfileDataController.profileProvider);

    return Scaffold(
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            final user = profile.user;

            // ✅ শুধু একবারই initial data বসবে
            if (!_isInitialized) {
              nameController.text = user.name ?? "";
              emailController.text = user.email ?? "";
              phoneController.text = user.phone ?? "";
              addressController.text = user.userAddress ?? "";
              _isInitialized = true;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHomeTopperSection(),
                  AbouteBackgrountImage(screenName: "Profile"),
                  SizedBox(height: 25.h),

                  /// Avatar
                  Center(
                    child: GestureDetector(
                      onTap: _showPickerOptions,
                      child: CircleAvatar(
                        radius: 40.r,
                        backgroundColor: Colors.grey[700],
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (user.userImage != null
                            ? NetworkImage(user.userImage!)
                            : null) as ImageProvider<Object>?,
                        child: (_pickedImage == null && user.userImage == null)
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// Fields
                  customField(context, label: "Name", controller: nameController),
                  customField(context, label: "Email", controller: emailController),
                  customField(context, label: "Phone", controller: phoneController),
                  customField(context, label: "Address", controller: addressController),

                  SizedBox(height: 10.h),

                  /// Upload + Update Button
                  imageUpload(),

                  SizedBox(height: 10.h),
                  FooterSection(),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error loading profile: $err")),
        ),
      ),
    );
  }

  /// ---------- IMAGE PICKER ----------
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
    Navigator.pop(context); // BottomSheet বন্ধ করার জন্য
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.orange),
                title: const Text("Camera",
                    style: TextStyle(color: Colors.white)),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.red),
                title: const Text("Gallery",
                    style: TextStyle(color: Colors.white)),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ---------- CUSTOM FIELD ----------
  Widget customField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 8.h),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1F1F1F),
              hintText: "Enter $label",
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- IMAGE UPLOAD + UPDATE ----------
  Widget imageUpload() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile Image",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10.h),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _pickedImage != null
                        ? _pickedImage!.path.split("/").last
                        : "Choose File..",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                GestureDetector(
                  onTap: _showPickerOptions,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.red],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text("BROWSE",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
      InkWell(
        onTap: () async {
          try {
            await ref
                .read(ProfileDataController.profileUpdateController.notifier)
                .updateProfile(
              name: nameController.text,
              email: emailController.text,
              phone: phoneController.text,
              address: addressController.text,
              imageFile: _pickedImage,
            );

            // 🔑 Update successful হলে আবার profile provider refresh করো

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Profile updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Update failed: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text("UPDATE", style: TextStyle(color: Colors.white)),
        ),
      ),

      
        ],
      ),
    );
  }
}