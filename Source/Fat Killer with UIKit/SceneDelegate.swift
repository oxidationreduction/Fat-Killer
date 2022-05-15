//
//  SceneDelegate.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/22.
//

import UIKit
import SwiftUI
import HealthKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var modelData = ModelData()

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Thread.sleep(forTimeInterval: 2)
        
        self.loadAndDisplayMostRecentHeight()
        self.loadAndDisplayMostRecentWeight()
        
        if let temp = UserDefaults().getCustomObj(for: "curProject") {
            self.modelData.project = temp as! Project
            finalModelData.project = temp as! Project
        } else {
            editorActive = true
            firstEdit = true
        }
        
        if let temp = UserDefaults().getCustomObj(for: "notification") {
            self.modelData.notification = temp as! notification
            finalModelData.notification = temp as! notification
        } else {
            self.modelData.notification = emptyNotification
            finalModelData.notification = emptyNotification
        }
        
        let contentView = ContentView()
                            .environmentObject(modelData)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func loadAndDisplayMostRecentHeight() {
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
            
        ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
              
            guard let sample = sample else {
                print("Height Sample Acquire Failed.")
                return
            }
           
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.modelData.profile.height = heightInMeters
            finalModelData.profile.height = heightInMeters
        }
    }
    
    private func loadAndDisplayMostRecentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Weight Sample Type is no longer available in HealthKit")
            return
        }
            
        ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
              
            guard let sample = sample else {
                print("Weight Sample Acquire Failed.")
                return
            }
          
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.modelData.profile.weight = weightInKg
            finalModelData.profile.weight = weightInKg
        }
    }
    private func loadStartWeight() {
        print("StartDate: ", self.modelData.project.startDate)
        loadSingleWeight(startDate: self.modelData.project.startDate.addingTimeInterval(-86400),
                         endDate: Date(), ascending: true)
        
        if !weightSampleAcquired {
            print("Loading data.")
            loadSingleWeight(startDate: Date.distantPast,
                             endDate: self.modelData.project.startDate.addingTimeInterval(86400),
                             ascending: false)
        }
    }
    
    private func loadSingleWeight(startDate: Date, endDate: Date, ascending: Bool) {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Weight Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getSingleSample(for: weightSampleType,
                                         startDate: startDate,
                                         endDate: endDate,
                                         ascending: ascending) { (sample, error) in
              
            guard let sample = sample else {
                print("Weight Sample Acquire Failed.")
                return
            }
          
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.modelData.project.startWeight = weightInKg
            print("SceneDelegate: modelData.project.startWeight = ", self.modelData.project.startWeight)
            weightSampleAcquired = true
        }
    }
}
