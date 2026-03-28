//
//  ProfileVC.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 27/03/26.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfileVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFieldUserName: UIView!
    @IBOutlet weak var txtFieldEmail: UIView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUserProfileData()
    }

    // MARK: - UI Setup
    func setupUI() {
        UIHelper.makeRounded(view: btnUpdate, radius: 8)
        UIHelper.makeRounded(view: btndelete, radius: 8)

        viewUserName.setCornerWithBorder(radius: 8)
        viewEmail.setCornerWithBorder(radius: 8)

        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        imgProfile.clipsToBounds = true
    }

    // MARK: - Load User Data
    func setUserProfileData() {

        let defaults = UserDefaults.standard

        (txtFieldUserName as? UITextField)?.text = defaults.string(forKey: "user_name")
        (txtFieldEmail as? UITextField)?.text = defaults.string(forKey: "user_email")

        if let photoURL = defaults.string(forKey: "user_photo"),
           let url = URL(string: photoURL) {
            loadImage(from: url)
        }
    }

    // MARK: - Image Loader
    func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imgProfile.image = UIImage(data: data)
                }
            }
        }
    }

    // MARK: - Logout
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch {
            print("Logout error:", error.localizedDescription)
        }

        clearUserSession()
    }

    // MARK: - Delete Account
    func deleteAccount() {

        guard let user = Auth.auth().currentUser else { return }

        user.delete { error in
            if let error = error {
                print("Delete account error:", error.localizedDescription)
                return
            }

            print("Account deleted successfully")
            self.clearUserSession()
        }
    }

    // MARK: - Clear Session
    func clearUserSession() {

        let defaults = UserDefaults.standard
        ["user_uid", "user_email", "user_name", "user_photo"].forEach {
            defaults.removeObject(forKey: $0)
        }

        defaults.set(false, forKey: "isLoggedIn")

        navigateToLogin()
    }

    // MARK: - Navigation
    func navigateToLogin() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = loginVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    // MARK: - Actions

    @IBAction func btnUpdateClick(_ sender: UIButton) {
        
    }

    @IBAction func btnDeleteAccountClick(_ sender: Any) {
        UIAlertController.showConfirmationAlert(
            on: self,
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            confirmTitle: "Delete",
            confirmStyle: .destructive
        ) {
            self.deleteAccount()
        }
    }

    @IBAction func btnLogOutClick(_ sender: UIBarButtonItem) {
        UIAlertController.showConfirmationAlert(
            on: self,
            title: "Logout",
            message: "Are you sure you want to logout?",
            confirmTitle: "Logout",
            confirmStyle: .destructive
        ) {
            self.logoutUser()
        }
    }
}
