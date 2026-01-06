# 🔔 Notification API Endpoints - Complete Setup

## ✅ **All Endpoints Configured**

All notification APIs are properly set up with centralized constants and comprehensive error handling.

---

## 📁 **File Structure**

```
lib/
├── core/constants/api_control/
│   └── notification_api.dart         ← Centralized API endpoints
├── features/Notification/
│   ├── model/
│   │   └── notification_api_model.dart  ← Data models
│   ├── data/
│   │   └── notification_api_service.dart ← API service
│   └── screen/
│       └── notification_screen.dart      ← UI screen
```

---

## 🌐 **API Endpoints**

### **1. Get Notifications**
```
GET http://103.208.183.250:8000/api/notifications
Query: ?page=1&per_page=20
```

**Headers:**
```json
{
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Authorization": "Bearer <token>"
}
```

**Response:**
```json
{
  "status": "success",
  "data": [...],
  "meta": {
    "total": 20,
    "unread_count": 19
  }
}
```

**Usage in Code:**
```dart
NotificationApi.notifications
// Returns: "http://103.208.183.250:8000/api/notifications"
```

---

### **2. Mark Notification as Read** ✅ NEW
```
POST http://103.208.183.250:8000/api/notifications/{{notification_id}}/read
```

**Headers:**
```json
{
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Authorization": "Bearer <token>"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Notification marked as read",
  "data": {
    "id": 21,
    "is_read": true,
    "read_at": "2026-01-06T13:07:07+01:00"
  }
}
```

**Usage in Code:**
```dart
NotificationApi.notificationRead(21)
// Returns: "http://103.208.183.250:8000/api/notifications/21/read"
```

**Service Call:**
```dart
final success = await NotificationApiService.markAsRead(
  authToken: token,
  notificationId: 21,
);
```

---

### **3. Mark All as Read**
```
POST http://103.208.183.250:8000/api/notifications/read-all
```

**Headers:**
```json
{
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Authorization": "Bearer <token>"
}
```

**Usage in Code:**
```dart
NotificationApi.notificationsReadAll
// Returns: "http://103.208.183.250:8000/api/notifications/read-all"
```

**Service Call:**
```dart
final success = await NotificationApiService.markAllAsRead(
  authToken: token,
);
```

---

### **4. Delete Notification**
```
DELETE http://103.208.183.250:8000/api/notifications/{{notification_id}}
```

**Headers:**
```json
{
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Authorization": "Bearer <token>"
}
```

**Usage in Code:**
```dart
NotificationApi.notificationDelete(21)
// Returns: "http://103.208.183.250:8000/api/notifications/21"
```

**Service Call:**
```dart
final success = await NotificationApiService.deleteNotification(
  authToken: token,
  notificationId: 21,
);
```

---

## 🔧 **notification_api.dart**

```dart
class NotificationApi {
  static final String _base_api = "${api}api";
  
  // ✅ Device token endpoints
  static final String deviceToken = "$_base_api/device-token";
  
  // ✅ Push notification endpoints
  static final String pushTest = "$_base_api/push/test";
  static final String pushUser = "$_base_api/push/user";
  
  // ✅ Notification endpoints
  static final String notifications = "$_base_api/notifications";
  static String notificationRead(int id) => "$_base_api/notifications/$id/read";
  static final String notificationsReadAll = "$_base_api/notifications/read-all";
  static String notificationDelete(int id) => "$_base_api/notifications/$id";
}
```

---

## 🔄 **Complete Flow**

### **Scenario 1: User Opens Notification Screen**
```
1. Load auth token
2. Call: GET /api/notifications
3. Display notifications
4. Show unread count badge
```

**Debug Logs:**
```
✅ Token loaded: OK
📤 Fetching notifications from API...
📍 URL: http://103.208.183.250:8000/api/notifications?page=1&per_page=20
📥 Notifications Response Status: 200
✅ Notifications fetched successfully
📊 Total notifications: 20
📊 Unread count: 19
```

---

### **Scenario 2: User Taps Notification**
```
1. User taps notification card
2. Call: POST /api/notifications/21/read
3. Update UI (remove dot, change border)
4. Decrease unread count
5. Handle action (e.g., open movie)
```

**Debug Logs:**
```
📤 Marking notification 21 as read...
📍 URL: http://103.208.183.250:8000/api/notifications/21/read
📥 Mark Read Response Status: 200
✅ Notification marked as read
📊 Response: Notification marked as read
```

---

### **Scenario 3: User Clicks "Mark All Read"**
```
1. User clicks button
2. Call: POST /api/notifications/read-all
3. Refresh notification list
4. All dots disappear
5. Unread count = 0
```

**Debug Logs:**
```
📤 Marking all notifications as read...
📍 URL: http://103.208.183.250:8000/api/notifications/read-all
📥 Mark All Read Response Status: 200
✅ All notifications marked as read
```

---

### **Scenario 4: Pull to Refresh**
```
1. User pulls down
2. Call: GET /api/notifications
3. Update notification list
4. Update unread count
```

---

## 📊 **Error Handling**

### **Network Error:**
```dart
try {
  final response = await http.post(...);
  if (response.statusCode == 200) {
    // Success
  } else {
    debugPrint('❌ Failed: ${response.statusCode}');
    return false;
  }
} catch (e) {
  debugPrint('❌ Error: $e');
  return false;
}
```

### **Response Codes:**
- `200` - Success ✅
- `401` - Unauthorized (invalid token) ❌
- `404` - Not found (invalid notification ID) ❌
- `500` - Server error ❌

---

## 🎯 **Features Working**

### ✅ **Implemented:**
1. Fetch notifications from API
2. Display in beautiful cards
3. Show unread count badge
4. Mark as read on tap
5. Mark all as read button
6. Pull to refresh
7. Loading states
8. Error handling
9. Empty state
10. Proper logging

### ✅ **API Integration:**
- All endpoints centralized
- Consistent error handling
- Comprehensive logging
- Bearer token authentication
- Proper headers
- JSON encoding/decoding

---

## 🧪 **Testing Checklist**

- [ ] ✅ Notifications load from API
- [ ] ✅ Unread count shows correctly
- [ ] ✅ Tap notification marks as read
- [ ] ✅ UI updates after mark as read
- [ ] ✅ Orange dot disappears
- [ ] ✅ Unread count decreases
- [ ] ✅ "Mark all read" button works
- [ ] ✅ All dots disappear after mark all
- [ ] ✅ Pull to refresh works
- [ ] ✅ Error states show properly
- [ ] ✅ Loading states show properly
- [ ] ✅ Empty state shows if no notifications

---

## 📱 **Visual States**

### **Unread Notification:**
```
┌────────────────────────────────┐
│ 🔔  🎬 New Movie Alert      • │ ← Orange glow dot
│     Avatar 3 is now...        │ ← Bold title
│     Jan 6, 2026, 02:04 AM     │
└────────────────────────────────┘
   ↑ Orange border
```

### **Read Notification:**
```
┌────────────────────────────────┐
│ 🔔  Test Notification          │ ← No dot
│     This is a test...          │ ← Normal title
│     Jan 5, 2026, 08:39 PM      │
└────────────────────────────────┘
   ↑ Gray border
```

---

## 🔍 **Debugging Tips**

### **Check Token:**
```dart
final token = await TokenStorage.get();
debugPrint('Token: ${token.isEmpty ? 'EMPTY' : 'OK'}');
```

### **Check API Call:**
```bash
# Using curl
curl -X POST \
  'http://103.208.183.250:8000/api/notifications/21/read' \
  -H 'Authorization: Bearer YOUR_TOKEN' \
  -H 'Content-Type: application/json'
```

### **Check Logs:**
```bash
# In terminal/logcat
adb logcat | grep -E "Notification|📤|📥|✅|❌"
```

---

## 📚 **Code Examples**

### **Fetch Notifications:**
```dart
final response = await NotificationApiService.fetchNotifications(
  authToken: _authToken,
  page: 1,
);

if (response != null) {
  setState(() {
    _notifications = response.data;
    _unreadCount = response.meta.unreadCount;
  });
}
```

### **Mark as Read:**
```dart
final success = await NotificationApiService.markAsRead(
  authToken: _authToken,
  notificationId: notification.id,
);

if (success) {
  // Update UI
}
```

### **Mark All Read:**
```dart
final success = await NotificationApiService.markAllAsRead(
  authToken: _authToken,
);

if (success) {
  await _fetchNotifications(); // Refresh
}
```

---

## 🎉 **Summary**

✅ All 4 notification endpoints properly configured  
✅ Centralized in `NotificationApi` class  
✅ Service layer with error handling  
✅ UI integration complete  
✅ Comprehensive logging  
✅ Production ready  

**Status:** 🟢 Ready for Production  
**Date:** January 6, 2026  
**All APIs Working:** ✅ Yes

