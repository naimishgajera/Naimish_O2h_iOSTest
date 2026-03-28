//
//  AppContants.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 28/03/26.
//

import UIKit

class UIHelper {
    
    static func makeRounded(view: UIView, radius: CGFloat = 12) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
}

// MARK: - Layout Constants
enum LayoutConstants {
    static let sectionPadding: CGFloat = 15
    static let interitemSpacing: CGFloat = 10
    static let numberOfColumns: CGFloat = 2
    static let cellHeightOffset: CGFloat = 60
}

let _application    = UIApplication.shared
let _appDelegator   = _application.delegate! as! AppDelegate
let profileData = "profileData"
let _userDefault  = UserDefaults.standard
