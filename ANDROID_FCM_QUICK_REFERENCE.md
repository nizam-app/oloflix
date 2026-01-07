# Android FCM Token - Quick Reference Guide

## 🔥 Firebase Connection Status: ✅ CONNECTED

### Configuration Files:
- ✅ `android/app/google-services.json` - Properly configured
- ✅ `android/app/build.gradle.kts` - Google Services plugin added
- ✅ `android/build.gradle.kts` - Google Services plugin version set
- ✅ `pubspec.yaml` - Firebase dependencies installed

### Firebase Details:
- **Project ID:** `oloflix-304db`
- **Package Name:** `Oloflix.app`
- **Android App ID:** `1:872422278804:android:96f68004c30c075ef51681`

---

## 📱 FCM Token Flow - Android

### **1. App Start (main.dart)**
```
Firebase.initializeApp() 
  → Get FCM Token (Android - direct)
  → Save to SharedPreferences
  → Ready for login
```

### **2. User Login**
```
LoginController.login()
  → Reset PushNotificationManager
  → Get FCM Token (current or saved)
  → POST /api/device-token
  → Save to database
  → Force resend after 2s (fallback)
```

### **3. Token Sources (Priority)**
1. **Current token** from Firebase (fresh)
2. **Saved token** from SharedPreferences
3. **Token refresh** listener (when available)

---

## 🔧 Key Code Locations

### **Firebase Initialization:**
- **File:** `lib/main.dart`
- **Lines:** 32-89
- **Function:** `main()`

### **Login Token Send:**
- **File:** `lib/features/auth/logic/loging_controller.dart`
- **Lines:** 69-87
- **Function:** `login()`

### **Token Retrieval (Android):**
- **File:** `lib/features/Notification/screen/push_notification_manager.dart`
- **Lines:** 127-141
- **Platform Check:** `Platform.isAndroid`

### **API Call:**
- **File:** `lib/features/Notification/data/fcm_token_service.dart`
- **Lines:** 11-49
- **Endpoint:** `http://103.208.183.250:8000/api/device-token`

---

## 📊 Expected Logs

### **App Start:**
```
✅ Firebase initialized
🔔 Notification permission: authorized
🔥 FCM Token (Full): <token>
💾 FCM token saved locally
```

### **Login:**
```
🔥 Initializing FCM after login...
🤖 Android detected, retrieving FCM token...
✅ Android FCM token retrieved: <token>...
📤 Sending FCM token to backend...
📍 Endpoint: http://103.208.183.250:8000/api/device-token
✅ Token sent to backend successfully
```

---

## 🐛 Common Issues & Quick Fixes

### **Token is Null:**
- Check internet connection
- Verify Firebase project is active
- Check `google-services.json` package name

### **Token Not Sent:**
- Check auth token is valid
- Verify endpoint URL
- Check network connectivity

### **Token Sent But Not Saved:**
- Check backend logs
- Verify database connection
- Check API implementation

---

## ✅ Verification Steps

1. **Check Firebase Connection:**
   - Look for `✅ Firebase initialized` in logs

2. **Check Token Retrieval:**
   - Look for `✅ Android FCM token retrieved` in logs

3. **Check Token Send:**
   - Look for `✅ Token sent to backend successfully` in logs

4. **Verify Database:**
   - Check backend database for token entry

---

## 🎯 Summary

**Status:** ✅ Android Firebase & FCM Fully Configured

**Flow:**
1. App starts → Firebase initialized → Token retrieved → Saved locally
2. User logs in → Token retrieved → Sent to backend → Saved in database
3. Token refresh → Automatically sent when token updates

**All systems operational!** 🚀

