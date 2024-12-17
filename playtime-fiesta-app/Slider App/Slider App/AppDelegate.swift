import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

            // Initialize the window and set the bounds to the screen
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()

            // Initialize the flow layout
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal // Horizontal scrolling for swiping effect

            // Initialize the SwipingController with the layout
            let swipingController = SwipingController(collectionViewLayout: layout)

            // Set the root view controller to the SwipingController
            window?.rootViewController = swipingController

            return true
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

