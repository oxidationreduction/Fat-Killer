//
//  AppDelegate.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/22.
//

import UIKit

var formatter = DateFormatter()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        authorizeHealthKit()
        formatter.dateStyle = .medium
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

func authorizeHealthKit() {
    HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
          
        guard authorized else {
            
            let baseMessage = "HealthKit Authorization Failed"
            
            if let error = error {
                print("\(baseMessage). Reason: \(error.localizedDescription)")
            } else {
                print(baseMessage)
            }
            
            return
        }
    }
}
