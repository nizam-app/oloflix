# FCM Token Flow Implementation

## Overview
FCM (Firebase Cloud Messaging) token এখন automatically backend এ send হবে দুইটি scenario তে:

1. **When user logs in** (নতুন login করার সময়)
2. **When app starts with logged-in user** (যখন user already logged in থাকে)

---

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     APP STARTS (Splash)                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ├─── Check SharedPreferences ───┐
                       │                                 │
                       ▼                                 ▼
          ┌─────────────────────┐         ┌──────────────────────┐
          │  Token Found?       │         │   No Token           │
          │  (User logged in)   │         │   (Not logged in)    │
          └─────────┬───────────┘         └──────────┬───────────┘
                    │                                  │
                    ▼                                  │
          ┌─────────────────────┐                     │
          │ Get FCM Token       │                     │
          │ from Firebase       │                     │
          └─────────┬───────────┘                     │
                    │                                  │
                    ▼                                  │
          ┌─────────────────────┐                     │
          │ POST /device-token  │                     │
          │ with auth token     │                     │
          └─────────┬───────────┘                     │
                    │                                  │
                    ▼                                  │
          ┌─────────────────────┐                     │
          │ Navigate to Home    │◄────────────────────┘
          └─────────────────────┘
                    
                    
┌─────────────────────────────────────────────────────────────┐
│                    USER LOGIN FLOW                           │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
          ┌─────────────────────┐
          │ User enters email   │
          │ and password        │
          └─────────┬───────────┘
                    │
                    ▼
          ┌─────────────────────┐
          │ POST /api/login     │
          └─────────┬───────────┘
                    │
                    ├─── Success (200) ───┐
                    │                       │
                    ▼                       ▼
          ┌─────────────────────┐   ┌──────────────────┐
          │ Save token to       │   │  Show error      │
          │ SharedPreferences   │   │  message         │
          └─────────┬───────────┘   └──────────────────┘
                    │                       
                    ▼                       
          ┌─────────────────────┐          
          │ Invalidate providers│          
          │ & fetch profile     │          
          └─────────┬───────────┘          
                    │                       
                    ▼                       
          ┌─────────────────────┐          
          │ Get FCM Token       │          
          │ from Firebase       │          
          └─────────┬───────────┘          
                    │                       
                    ▼                       
          ┌─────────────────────┐          
          │ POST /device-token  │          
          │ with auth token     │          
          └─────────┬───────────┘          
                    │                       
                    ▼                       
          ┌─────────────────────┐          
          │ Navigate to Home    │          
          └─────────────────────┘          
```

---

## API Request Details

### Endpoint
```
POST {{base_url_oloflixMovies}}/device-token
```

### Headers
```json
{
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Authorization": "Bearer <auth_token>"
}
```

### Request Body
```json
{
  "token": "cc1PSFsw03eE7GFHmixZdPA:PA91bEt2tochyGELH3exVc-SD_0Iazy-yK5Ao_$Fd0kpyMT8JxYToPtm8vdTKaKux6ZycnHKenLxYqn25bMVS$bLbTIxxtmmmnMk-PSI-HHj_sjMHy_9hFI",
  "platform": "android"
}
```

---

## Modified Files

### 1. `lib/features/auth/logic/loging_controller.dart`
- ✅ Added import for `PushNotificationManager`
- ✅ After successful login, calls `PushNotificationManager.init()` with auth token
- ✅ Error handling - doesn't block login if FCM fails

### 2. `lib/features/auth/screens/splash_screen.dart`
- ✅ Added import for `PushNotificationManager`
- ✅ In `loginCheck()` method, checks if user is already logged in
- ✅ If logged in, calls `PushNotificationManager.init()` with saved token
- ✅ Runs before navigation to home screen

### 3. `lib/features/Notification/data/fcm_token_service.dart`
- ✅ Updated request body field from `device_token` to `token` (matching Postman)

---

## Key Features

### 1. **Automatic Token Sending**
- No manual intervention needed
- Happens automatically on login and app start

### 2. **Token Refresh Handling**
- `PushNotificationManager` listens for token refresh
- Automatically sends new token to backend when FCM token changes

### 3. **Error Handling**
- If FCM token sending fails, it doesn't block user flow
- Errors are logged for debugging
- User can still use the app normally

### 4. **Platform Detection**
- Automatically detects platform (android, ios, etc.)
- Sends platform info to backend

### 5. **Token Storage**
- FCM token is saved locally in SharedPreferences
- Timestamp is saved for tracking

---

## Testing

### Test Scenario 1: Fresh Login
1. Clear app data or use new user
2. Open app
3. Login with email/password
4. ✅ Check logs for: `🔥 Initializing FCM after login...`
5. ✅ Check logs for: `✅ FCM token sent to backend successfully`
6. ✅ Verify backend received the token

### Test Scenario 2: Already Logged In
1. Login once and close app
2. Reopen app (should show splash)
3. ✅ Check logs for: `🔥 User already logged in. Sending FCM token...`
4. ✅ Check logs for: `✅ FCM token sent successfully on app start`
5. ✅ Verify backend received the token

### Test Scenario 3: Token Refresh
1. Keep app open for extended period
2. FCM token may refresh automatically
3. ✅ Check logs for: `♻️ FCM Token refreshed`
4. ✅ New token should be sent to backend

---

## Debug Logs

### Success Logs
```
🔥 Initializing FCM after login...
🚀 Initializing PushNotificationManager...
🔔 Permission status: AuthorizationStatus.authorized
🔥 FCM Token obtained: cc1PSFsw03eE7GFHmix...
📤 Sending FCM token to backend...
✅ FCM token sent successfully
✅ FCM token sent to backend successfully
```

### Error Logs
```
⚠️ Failed to send FCM token: <error_message>
❌ Failed to send FCM token to backend
```

---

## Important Notes

1. **Firebase Must Be Initialized**
   - Firebase is already initialized in `main.dart`
   - Don't worry about this

2. **Permissions**
   - Notification permissions are requested automatically
   - If user denies, token won't be sent (by design)

3. **Token Uniqueness**
   - Each device has a unique FCM token
   - Backend should store device-specific tokens

4. **Security**
   - Token is sent with Bearer auth header
   - Backend should validate the auth token

---

## Future Enhancements

- [ ] Retry mechanism if token sending fails
- [ ] Batch token updates
- [ ] Token deletion on logout
- [ ] Multiple device management

---

**Implementation Date:** January 5, 2026  
**Status:** ✅ Complete and Tested

