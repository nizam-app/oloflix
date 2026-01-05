# Ad System Testing Instructions

## 🎯 Quick Test Guide

### Prerequisites
- App running on device/emulator
- Access to free videos
- Ability to log in/out

---

## Test Scenario 1: Guest User (Ads Enabled) 🎬

### Setup:
1. **Log out** completely from the app
2. Clear any saved tokens (or reinstall app)

### Steps:
1. Open the app (should work without login)
2. Navigate to home screen
3. Find a **FREE** video
4. Click **Watch** or **Play** button

### Expected Results:
✅ Video starts playing immediately  
✅ **After 3 seconds**: 
   - Main video pauses
   - First ad starts playing
   - Yellow "AD" label appears in top-right corner
   - Video controls are hidden

✅ **After ad finishes** (~30 seconds):
   - Ad disappears
   - Main video resumes from where it paused
   - Controls reappear
   - Time counter continues

✅ **After 5 minutes** of main video:
   - Second ad plays
   - Same behavior as first ad

✅ **Continue pattern** for remaining ads (10min, 15min, 20min)

### Console Logs to Look For:
```
🔐 Login status checked: Guest
👤 Guest user - Ads will be ENABLED
🎬 Fetching player ads from: http://103.208.183.250:8000/api/player-ads
📥 Response status: 200
✅ Player ads loaded successfully
   Show ads: true
   Number of ads: 5
   Ad 1: 00:00:03 - https://oloflix.b-cdn.net/ADVERTS/...
🎬 Playing ad 1 at 00:00:03
   Source: https://oloflix.b-cdn.net/ADVERTS/...
✅ Ad 1 completed
   Marked ad 1 as played (1/5)
```

### What NOT to See:
❌ No login prompts for free videos  
❌ No errors or crashes  
❌ No ad replays (each ad plays only once)  
❌ Main video doesn't jump or restart after ads  

---

## Test Scenario 2: Logged-In User (Ads Disabled) 🚫

### Setup:
1. **Log in** to your account
2. Verify token is saved (check with your login flow)

### Steps:
1. Navigate to home screen
2. Find any video (FREE, PAID, or PPV)
3. Click **Watch** or **Play** button
4. Watch for at least 10 minutes

### Expected Results:
✅ Video starts playing  
✅ **NO ads at any point**  
✅ Video plays continuously  
✅ No "AD" label appears  
✅ No pauses at 3s, 5min, 10min marks  
✅ Smooth uninterrupted playback  

### Console Logs to Look For:
```
🔐 Login status checked: Logged In
✅ User logged in - Ads will be DISABLED
🚫 Skipping ad initialization - User is logged in
```

### What NOT to See:
❌ No ads at all  
❌ No yellow "AD" label  
❌ No pauses at ad trigger times  
❌ No ad fetching logs  

---

## Test Scenario 3: Multiple Videos

### Setup:
Log out (for ads testing)

### Steps:
1. Play a free video
2. Watch until first ad plays (at 3 seconds)
3. **Close the video** (go back)
4. Open **another** free video
5. Watch until first ad

### Expected Results:
✅ First video: Ad plays at 3 seconds  
✅ **Second video**: Ad plays at 3 seconds again (fresh session)  
✅ Each video has its own ad tracking  
✅ Closing video resets ad state  

---

## Test Scenario 4: Ad Skipping for Non-Video Ads

### Setup:
Log out, play free video

### Steps:
1. Fast forward to around 19:50 (use seek if possible)
2. Wait for 20:00 mark

### Expected Results:
✅ Console shows: "⚠️ Skipping non-video ad"  
✅ Main video continues playing  
✅ No blank screen or pause  
✅ Link ad (https://pitamchandra.github.io) is skipped  

---

## Test Scenario 5: Network Failure Handling

### Setup:
1. Log out
2. **Disable internet** on device
3. Open app and play free video

### Expected Results:
✅ Video may fail to load (expected)  
✅ **OR** video plays without ads (if cached)  
✅ No crashes  
✅ Graceful error handling  
✅ Console shows: "❌ Error fetching player ads"  

### After Re-enabling Internet:
1. Close and reopen video
2. Ads should work normally again

---

## Common Issues & Solutions

### Issue: "Ads not playing for guest users"

**Possible Causes:**
1. User is actually logged in (check token)
2. API not responding
3. Ad URLs are blocked/invalid
4. Network connectivity issues

**Debug:**
```
Check console for:
- "🔐 Login status checked: Guest" ✅
- "✅ Player ads loaded successfully" ✅
- "🎬 Playing ad X at 00:00:0X" ✅
```

**Fix:**
- Verify logout (clear SharedPreferences)
- Test API URL in browser: http://103.208.183.250:8000/api/player-ads
- Check device internet connection

---

### Issue: "Ads playing for logged-in users"

**Possible Causes:**
1. Token not saved properly
2. Login check failing
3. State not updating

**Debug:**
```
Check console for:
- "🔐 Login status checked: Logged In" ✅
- "🚫 Skipping ad initialization" ✅
```

**Fix:**
- Verify token exists: `SharedPreferences.getString('token')`
- Force logout and login again
- Restart app after login

---

### Issue: "Main video doesn't resume after ad"

**Possible Causes:**
1. Ad completion listener not firing
2. Ad controller not disposing
3. Network issue loading ad

**Debug:**
```
Check console for:
- "✅ Ad X completed" ✅
```

**Fix:**
- Wait longer for ad to complete
- Check ad video URLs are accessible
- Restart video

---

### Issue: "Ads replaying multiple times"

**Possible Causes:**
1. Played ads set not working
2. State reset incorrectly

**Debug:**
```
Check console for:
- "Marked ad X as played (N/5)" ✅
```

**Fix:**
- Should show increasing count (1/5, 2/5, etc.)
- If stuck at 0/5, there's a state issue
- Close and reopen video

---

## Performance Checklist

- [ ] Video loads quickly
- [ ] No lag during ad transitions
- [ ] Smooth playback throughout
- [ ] No memory leaks (check with profiler)
- [ ] Battery usage reasonable
- [ ] Network usage reasonable

---

## Success Criteria

✅ **Guest users:**
- See ads at 3s, 5min, 10min, 15min, 20min
- Ads play smoothly
- Main video resumes correctly
- No crashes or errors

✅ **Logged-in users:**
- See ZERO ads
- Uninterrupted playback
- Premium experience

✅ **General:**
- No app crashes
- Graceful error handling
- Good user experience

---

## Report Template

If you find issues, please report with:

```
**Issue:** [Brief description]

**User Type:** Guest / Logged In

**Steps to Reproduce:**
1. ...
2. ...
3. ...

**Expected:** 
What should happen

**Actual:** 
What actually happened

**Console Logs:**
[Paste relevant logs]

**Video URL:**
[If relevant]

**Device:**
Android/iOS, version

**App Version:**
[Your version]
```

---

## 🎉 Ready to Test!

Run: `flutter run`

Follow the test scenarios above and enjoy the new ad system! 🚀

