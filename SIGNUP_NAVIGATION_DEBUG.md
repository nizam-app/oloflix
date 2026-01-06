# 🔍 Signup Navigation Debugging Guide

## ⚠️ **IMPORTANT: Full App Restart Required**

Hot reload **WILL NOT WORK** for navigation changes!  
You must do a **FULL RESTART** of the app.

---

## 🚀 **How to Test Properly**

### **Method 1: Full Restart (Recommended)**
```bash
# Stop the app completely
# Then run:
flutter run

# OR if app is already installed:
# 1. Close app completely on device
# 2. Reopen the app
# 3. Try signup
```

### **Method 2: Rebuild APK**
```bash
flutter build apk --release
# Install the new APK on device
```

### **Method 3: Clean Build**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📊 **Debug Logs to Check**

### **What You Should See After Signup:**

```
📤 Signup Request to: http://103.208.183.250:8000/api/signup
📥 Signup Response Status: 200
✅ Signup API returned success status!
📦 Full response data: {message: Signup successful, data: {...}}
📝 Token found in data["data"]["token"]
✅ Signup successful! Token received: Yes
📏 Token length: 450
✅ Profile fetched successfully
🔥 Initializing FCM after signup...
✅ FCM token sent to backend successfully
🏠 Starting navigation to Home screen...
🏠 HomeScreen.routeName = /homePage
🏠 context.mounted = true
✅ Context is mounted, navigating...
🎯 Executing navigation to: /homePage
✅ Navigation command executed!
```

### **If You See This (Problem):**

```
❌ Context not mounted, cannot navigate!
```
**Solution:** Context issue, the screen was disposed. Try adding delay.

```
⚠️ No token found in response!
```
**Solution:** Backend not returning token. Check backend response format.

```
🏠 context.mounted = false
```
**Solution:** Screen disposed too early. Check if there's a redirect happening elsewhere.

---

## 🔧 **Troubleshooting**

### **Problem 1: Still Goes to Login After Signup**

**Possible Causes:**
1. ❌ **App not restarted** - Hot reload doesn't work for navigation
2. ❌ **Old APK installed** - Need to rebuild and reinstall
3. ❌ **Context unmounted** - Check debug logs
4. ❌ **Backend returning error** - Check response status code

**Solutions:**
1. ✅ **Stop app completely** and restart
2. ✅ **Rebuild APK**: `flutter build apk --release`
3. ✅ **Check logs** for navigation messages
4. ✅ **Clear app data** before testing

---

### **Problem 2: No Debug Logs Showing**

**Solution:**
```bash
# Connect device via ADB
adb logcat | grep -E "Signup|Navigation|🏠|✅|❌"

# OR use VS Code/Android Studio debug console
```

---

### **Problem 3: App Crashes After Signup**

**Check for:**
- Missing providers
- HomeScreen.routeName mismatch
- Navigation stack issues

**Solution:**
```bash
# Check full crash logs
adb logcat | grep -E "FATAL|ERROR"
```

---

## 📱 **Step-by-Step Test**

### **Test Case: Fresh Signup**

1. ✅ **Stop the app completely** (kill from task manager)
2. ✅ **Restart the app**
3. ✅ **Open terminal for logs**:
   ```bash
   adb logcat | grep -E "Signup|Navigation|🏠"
   ```
4. ✅ **Navigate to Signup screen**
5. ✅ **Fill form:**
   - Name: "Test User"
   - Email: "test@example.com"
   - Password: "password123"
   - Confirm: "password123"
6. ✅ **Click SIGN UP**
7. ✅ **Watch logs carefully**
8. ✅ **Expected:** App goes to **HOME PAGE**

---

## 🎯 **Expected Behavior**

### **Success Flow:**
```
User clicks SIGN UP
    ↓
Loading indicator shows
    ↓
API call to /api/signup
    ↓
Response: 200 OK
    ↓
Token saved
    ↓
Success message shown
    ↓
Providers invalidated
    ↓
FCM token sent
    ↓
Navigation to /homePage ✅
    ↓
HOME PAGE APPEARS ✅
```

### **What Should Happen:**
- ✅ Green success message appears
- ✅ After 0.5 seconds, navigates to home
- ✅ Home page loads with movies
- ✅ User can start using app immediately

### **What Should NOT Happen:**
- ❌ Redirect to login page
- ❌ Stay on signup page
- ❌ App crash
- ❌ Blank screen

---

## 🔍 **Checking Current Code**

Run this to verify no login redirects exist:
```bash
grep -r "login_screen" lib/features/auth/logic/signup_controller.dart
# Should return: (no matches)
```

Check navigation line:
```bash
grep -n "context.go(HomeScreen" lib/features/auth/logic/signup_controller.dart
# Should show line with navigation to HomeScreen
```

---

## 💡 **Additional Debugging**

### **Add Temporary Alert Dialog:**

If you want to be 100% sure the success block is reached, add this before navigation:

```dart
// Add this after "✅ Signup successful!"
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('DEBUG'),
    content: Text('About to navigate to Home. Token: ${token.isNotEmpty}'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          context.go(HomeScreen.routeName);
        },
        child: Text('OK'),
      ),
    ],
  ),
);
```

---

## 📋 **Checklist**

Before reporting still not working:

- [ ] Stopped app completely (not just hot reload)
- [ ] Restarted app from scratch
- [ ] Checked debug logs for navigation messages
- [ ] Verified API returns 200 status code
- [ ] Confirmed token is received in response
- [ ] Checked no exceptions in logs
- [ ] Cleared app data and tried again
- [ ] Rebuilt APK and reinstalled

---

## 🆘 **If Still Not Working**

Provide these details:

1. **Debug logs** (full output from signup attempt)
2. **API response** (what backend returns)
3. **Status code** (200, 201, or error?)
4. **Token received?** (Yes/No)
5. **Navigation logs** (did you see "🎯 Executing navigation"?)
6. **What happens** (stays on signup? goes to login? crashes?)

---

**Key Point:** 🔴 **MUST RESTART APP** - Hot reload is not enough!

