# 🔔 Notification System - Integration Guide

## Quick Start

### Step 1: After User Login

Add this code after successful login:

```dart
import 'package:Oloflix/features/Notification/screen/push_notification_manager.dart';

// In your login success handler:
Future<void> _onLoginSuccess() async {
  final authToken = await TokenStorage.get();
  
  if (authToken.isNotEmpty) {
    // Initialize push notifications
    await PushNotificationManager.init(authToken: authToken);
    print('✅ Push notifications initialized');
  }
}
```

---

### Step 2: Show Unread Badge (Optional)

In your navigation bar or notification icon:

```dart
import 'package:Oloflix/features/Notification/data/notification_service.dart';

// Get unread count
FutureBuilder<int>(
  future: NotificationService.getUnreadCount(),
  builder: (context, snapshot) {
    final count = snapshot.data ?? 0;
    return Badge(
      label: Text('$count'),
      isLabelVisible: count > 0,
      child: Icon(Icons.notifications),
    );
  },
)
```

---

### Step 3: Handle Notification Navigation (Optional)

If you want to navigate when notification is tapped, update `notification_service.dart`:

```dart
// In _onNotificationTapped method:
static void _onNotificationTapped(NotificationResponse response) {
  if (response.payload != null) {
    final data = jsonDecode(response.payload!);
    
    // Navigate based on data
    if (data['type'] == 'movie') {
      // Navigate to movie details
      navigatorKey.currentState?.pushNamed(
        '/movie-details',
        arguments: data['movie_id'],
      );
    } else if (data['type'] == 'announcement') {
      // Navigate to announcements
      navigatorKey.currentState?.pushNamed('/announcements');
    }
  }
}
```

---

## Testing

### Test Backend Integration:

1. **Go to Notification Screen**
2. **Tap "Test Push"** - Sends test notification to all devices
3. **Tap "User Push"** - Sends notification to your logged-in account
4. **Check if notification appears**

### Expected Flow:

```
User logs in
  ↓
PushNotificationManager.init() called
  ↓
FCM token sent to backend
  ↓
Backend can now send notifications to this device
  ↓
User receives notifications
```

---

## Common Issues

### Issue 1: Token Not Sent to Backend

**Symptom:** Console shows "❌ Failed to send FCM token"

**Solution:**
- Check if backend endpoint `/api/device-token` exists
- Verify auth token is valid
- Check network connection
- Look at backend logs

### Issue 2: Notifications Not Showing

**Symptom:** FCM works but no system notification

**Solution:**
- Check app permissions (Android Settings > Apps > Oloflix > Notifications)
- Verify `flutter_local_notifications` is initialized
- Check console for errors

### Issue 3: Duplicate Notifications

**Symptom:** Each notification appears twice

**Solution:**
- Make sure main.dart doesn't have `FirebaseMessaging.onMessage.listen()`
- Only NotificationService should listen

---

## Complete Example

```dart
// After login in your login screen:

class LoginScreen extends StatefulWidget {
  // ... your login UI
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _handleLogin() async {
    // Your login logic...
    final response = await AuthService.login(email, password);
    
    if (response.success) {
      // Save token
      await TokenStorage.save(response.token);
      
      // ✅ Initialize push notifications
      await PushNotificationManager.init(
        authToken: response.token,
      );
      
      // Navigate to home
      context.go(HomeScreen.routeName);
    }
  }
}
```

---

## 🎉 That's It!

The notification system is ready. Just call `PushNotificationManager.init()` after login, and notifications will work automatically!

**Key Points:**
- ✅ Call after successful login
- ✅ Pass the auth token
- ✅ System handles everything else
- ✅ Notifications saved automatically
- ✅ Works in foreground, background, and terminated states

For detailed technical documentation, see `NOTIFICATION_SYSTEM_COMPLETE.md`.

