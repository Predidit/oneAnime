import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set notification delegate for background_downloader
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
