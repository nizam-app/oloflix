// Project imports:
import 'global_api.dart';

class AuthAPIController {
  static final String _base_api = "${api}api";
  static final String login = "$_base_api/login";
  static final String profile = "$_base_api/profile";
  static final String watchlist = "$_base_api/watchlist";
  static final String addWatchlist = "$watchlist/add";
  static final String removeWatchlist = "$watchlist/remove";
  static final String dashboard = "$_base_api/dashboard";
  static final String ads = "$_base_api/ads";
  static final String related_movie = "$_base_api/movies/details";


}