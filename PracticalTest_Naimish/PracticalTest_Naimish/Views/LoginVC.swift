//
//  LoginVC.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class LoginVC: UIViewController {

    @IBOutlet weak var btnSignInWithGoogle: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.makeRounded(view: btnSignInWithGoogle, radius: 25)
    }
    

    @IBAction func tapButtonSigninWithGoogle(_ sender: UIButton) {
        signInWithGoogle()
    }
    
    
    func signInWithGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in

            if let error = error {
                print("Google SignIn Error:", error)
                return
            }

            guard
                let user = signInResult?.user,
                let idToken = user.idToken?.tokenString
            else {
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in

                if let error = error {
                    print("Firebase login error:", error)
                    return
                }

                guard let firebaseUser = authResult?.user else { return }

                print("User logged in:", firebaseUser.email ?? "")

                // Save user data in UserDefaults
              
                _userDefault.set(firebaseUser.uid, forKey: "user_uid")
                _userDefault.set(firebaseUser.email, forKey: "user_email")
                _userDefault.set(firebaseUser.displayName, forKey: "user_name")
                _userDefault.set(firebaseUser.photoURL?.absoluteString, forKey: "user_photo")

                _userDefault.set(true, forKey: "isLoggedIn")
                _userDefault.synchronize()

                self.navigateToMainApp()
            }
        }
    }
        
    func navigateToMainApp() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController = tabBar
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
}
