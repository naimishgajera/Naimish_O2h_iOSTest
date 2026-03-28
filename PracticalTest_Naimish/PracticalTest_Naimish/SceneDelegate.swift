//
//  SceneDelegate.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }
        _appDelegator.window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

           let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

           if isLoggedIn {
               // Open Main TabBar
               let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
               window?.rootViewController = tabBarVC
           } else {
               // Open Login Screen
               let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
               window?.rootViewController = loginVC
           }
        
        _appDelegator.window?.makeKeyAndVisible()
    
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    // Handle incoming URLs via UIScene lifecycle (iOS 13+)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        let url = urlContext.url
        // Let Google Sign-In handle the URL
        if GIDSignIn.sharedInstance.handle(url) {
            return
        }
        // Handle other custom URL types here if needed.
    }

}

