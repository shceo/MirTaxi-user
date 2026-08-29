import UIKit
import Flutter
import YandexMapsMobile
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    // Ключ Yandex MapKit читаем из Info.plist (YandexMapsApiKey), чтобы он был
    // в одном месте и подменялся через xcconfig без правки кода.
    if let mapKitKey = Bundle.main.object(forInfoDictionaryKey: "YandexMapsApiKey") as? String,
       !mapKitKey.isEmpty {
      YMKMapKit.setApiKey(mapKitKey)
    }
    YMKMapKit.sharedInstance()
    GeneratedPluginRegistrant.register(with: self)
 UIApplication.shared.beginReceivingRemoteControlEvents()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
    override func applicationDidEnterBackground(_ application: UIApplication) {
                bgTask = application.beginBackgroundTask()
    }
    override func applicationDidBecomeActive(_ application: UIApplication) {
        application.endBackgroundTask(bgTask);
        application.applicationIconBadgeNumber = 0;
    }
}
