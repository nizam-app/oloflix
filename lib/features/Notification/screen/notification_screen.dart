import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/constants/api_control/token_store.dart';
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import '../data/notification_api_service.dart';
import '../model/notification_api_model.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static final routeName = "/notification_screen";

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = [];
  String _authToken = "";
  bool _isLoading = true;
  String? _errorMessage;
  int _unreadCount = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final token = await TokenStorage.get();
      setState(() => _authToken = token);
      debugPrint("✅ Token loaded: ${_authToken.isEmpty ? 'EMPTY' : 'OK (${_authToken.length} chars)'}");
      
      if (_authToken.isEmpty) {
        // Try alternative token key as fallback
        final prefs = await SharedPreferences.getInstance();
        final altToken = prefs.getString('token');
        if (altToken != null && altToken.isNotEmpty) {
          debugPrint("✅ Found token using alternative method");
          setState(() => _authToken = altToken);
        }
      }
      
      if (_authToken.isNotEmpty) {
        await _fetchNotifications();
      } else {
        // User not logged in - redirect to login screen
        debugPrint("❌ No token found - Redirecting to login");
        if (mounted) {
          context.push(LoginScreen.routeName);
        }
      }
    } catch (e) {
      debugPrint("❌ Error loading token: $e");
      // On error, also redirect to login as we can't verify authentication
      if (mounted) {
        context.push(LoginScreen.routeName);
      }
    }
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await NotificationApiService.fetchNotifications(
        authToken: _authToken,
        page: _currentPage,
      );

      if (response != null) {
        if (response.status == 'success') {
          setState(() {
            _notifications = response.data;
            _unreadCount = response.meta.unreadCount;
            _isLoading = false;
            _errorMessage = null;
          });
          debugPrint('✅ Loaded ${_notifications.length} notifications');
          debugPrint('✅ Unread count: $_unreadCount');
          
          if (_notifications.isEmpty) {
            debugPrint('ℹ️ No notifications found (empty list)');
          }
        } else {
          debugPrint('⚠️ API returned non-success status: ${response.status}');
          setState(() {
            _isLoading = false;
            _errorMessage = "Failed to load notifications: ${response.status}";
          });
        }
      } else {
        debugPrint('❌ API response is null');
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load notifications. Please check your connection and try again.";
        });
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = "Error loading notifications";
      });
    }
  }

  Future<void> _refreshNotifications() async {
    _currentPage = 1;
    await _fetchNotifications();
  }

  Future<void> _markAsRead(int notificationId) async {
    final success = await NotificationApiService.markAsRead(
      authToken: _authToken,
      notificationId: notificationId,
    );

    if (success) {
      // Update local state
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = NotificationItem(
            id: _notifications[index].id,
            title: _notifications[index].title,
            message: _notifications[index].message,
            type: _notifications[index].type,
            referenceId: _notifications[index].referenceId,
            createdAt: _notifications[index].createdAt,
            createdAtFormatted: _notifications[index].createdAtFormatted,
            isRead: true,
            readAt: DateTime.now().toIso8601String(),
            data: _notifications[index].data,
            imageUrl: _notifications[index].imageUrl,
            user: _notifications[index].user,
          );
          if (_unreadCount > 0) _unreadCount--;
        }
      });
    }
  }

  Future<void> _markAsUnread(int notificationId) async {
    final success = await NotificationApiService.markAsUnread(
      authToken: _authToken,
      notificationId: notificationId,
    );

    if (success) {
      // Update local state
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = NotificationItem(
            id: _notifications[index].id,
            title: _notifications[index].title,
            message: _notifications[index].message,
            type: _notifications[index].type,
            referenceId: _notifications[index].referenceId,
            createdAt: _notifications[index].createdAt,
            createdAtFormatted: _notifications[index].createdAtFormatted,
            isRead: false,
            readAt: null,
            data: _notifications[index].data,
            imageUrl: _notifications[index].imageUrl,
            user: _notifications[index].user,
          );
          _unreadCount++;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Marked as unread'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final success = await NotificationApiService.markAllAsRead(
      authToken: _authToken,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications marked as read'),
          backgroundColor: Colors.green,
        ),
      );
      await _fetchNotifications();
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'new_movies':
      case 'new_movie':
        return Icons.movie_outlined;
      case 'test':
        return Icons.science_outlined;
      case 'promotional':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Mark as read
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }

    // Handle notification action based on type
    if (notification.type == 'new_movies' || notification.type == 'new_movie') {
      // Navigate to movie details if movie_id exists
      if (notification.data != null && notification.data!['movie_id'] != null) {
        debugPrint('Navigate to movie: ${notification.data!['movie_id']}');
        // context.push('/movie/${notification.data!['movie_id']}');
      }
    }
  }

  void _showNotificationMenu(BuildContext context, NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // Mark as read/unread
            ListTile(
              leading: Icon(
                notification.isRead 
                    ? Icons.mark_email_unread 
                    : Icons.mark_email_read,
                color: AllColor.orange,
              ),
              title: Text(
                notification.isRead ? 'Mark as unread' : 'Mark as read',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                if (notification.isRead) {
                  _markAsUnread(notification.id);
                } else {
                  _markAsRead(notification.id);
                }
              },
            ),
            
            // Delete option (optional)
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red[300]),
              title: Text(
                'Delete notification',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle delete if needed
              },
            ),
            
            // Cancel
            SizedBox(height: 8.h),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.white60),
              title: Text(
                'Cancel',
                style: TextStyle(color: Colors.white60, fontSize: 16.sp),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.black,
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshNotifications,
          color: AllColor.orange,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHomeTopperSection(),
                SizedBox(height: 20.h),
                
                // "NOTIFICATIONS" Header with orange badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AllColor.orange,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "NOTIFICATIONS",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (_unreadCount > 0) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                '$_unreadCount',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // "Recent" Header with Mark All Read button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      if (_unreadCount > 0 && !_isLoading)
                        TextButton.icon(
                          onPressed: _markAllAsRead,
                          icon: Icon(Icons.done_all, size: 16.sp),
                          label: Text(
                            'Mark all read',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AllColor.orange,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          ),
                        ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16.h),

                // Loading indicator
                if (_isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.h),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: AllColor.orange),
                          SizedBox(height: 16.h),
                          Text(
                            'Loading notifications...',
                            style: TextStyle(color: Colors.white60, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  )
                // Error message
                else if (_errorMessage != null)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.h),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                          SizedBox(height: 16.h),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.white60, fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton.icon(
                            onPressed: _fetchNotifications,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AllColor.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // Notifications list
                else if (_notifications.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.h),
                      child: Column(
                        children: [
                          Icon(Icons.notifications_none, color: Colors.white30, size: 64.sp),
                          SizedBox(height: 16.h),
                          Text(
                            'No notifications yet',
                            style: TextStyle(color: Colors.white60, fontSize: 16.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Check back later for updates',
                            style: TextStyle(color: Colors.white38, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  _buildNotificationsList(_notifications),

                SizedBox(height: 60.h),
                FooterSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItem> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final notification = items[index];
        return _buildNotificationCard(
          icon: _getIconForType(notification.type),
          title: notification.title,
          message: notification.message,
          time: notification.createdAtFormatted,
          isUnread: !notification.isRead,
          onTap: () => _handleNotificationTap(notification),
          onLongPress: () => _showNotificationMenu(context, notification),
        );
      },
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isUnread 
              ? AllColor.orange.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
          width: isUnread ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left icon
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: isUnread 
                        ? AllColor.orange.withOpacity(0.15)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    isUnread ? Icons.notifications_active : icon,
                    color: isUnread ? AllColor.orange : Colors.white70,
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      
                      SizedBox(height: 6.h),
                      
                      // Message
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white60,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // Time
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white38,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Unread indicator
                if (isUnread)
                  Container(
                    width: 10.w,
                    height: 10.h,
                    margin: EdgeInsets.only(top: 6.h, left: 8.w),
                    decoration: BoxDecoration(
                      color: AllColor.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AllColor.orange.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
