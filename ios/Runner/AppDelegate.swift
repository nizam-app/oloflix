import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up notification center delegate for handling notifications
    // This is critical for foreground notifications to work
    UNUserNotificationCenter.current().delegate = self
    
    print("🔔 AppDelegate: Notification center delegate set")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle successful APNS registration
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    print("✅ APNS Device Token received: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    
    // Pass token to Firebase
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // Handle failed APNS registration
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    
    // Pass error to Firebase
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
  
  // Handle background notifications when app is not in foreground
  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    // Let Firebase handle the notification
    super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    
    // Log notification received
    print("🔔 Background notification received: \(userInfo)")
    
    // Complete the fetch
    completionHandler(.newData)
  }
  
  // Handle notification presentation when app is in FOREGROUND
  // This allows notifications to show even when app is open
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo
    
    print("🔔 Foreground notification received: \(userInfo)")
    
    // Show notification even when app is in foreground
    // Options: .banner, .sound, .badge, .list
    if #available(iOS 14.0, *) {
      completionHandler([[.banner, .sound, .badge]])
    } else {
      completionHandler([[.alert, .sound, .badge]])
    }
  }
  
  // Handle notification tap/interaction
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    
    print("👆 Notification tapped: \(userInfo)")
    
    // Let Firebase handle the notification tap
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    
    completionHandler()
  }
}
