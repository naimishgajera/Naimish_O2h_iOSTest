//
//  Extensions.swift
//  PracticalTest_Naimish
//
//  Created by Apple on 28/03/26.
//

import UIKit

extension UIView {
    
    func setCornerWithBorder(radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
    }
}

    extension UIAlertController {
        
        static func showConfirmationAlert(
            on viewController: UIViewController,
            title: String,
            message: String,
            confirmTitle: String,
            confirmStyle: UIAlertAction.Style = .default,
            cancelTitle: String = "Cancel",
            confirmHandler: @escaping () -> Void
        ) {
            
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            
            let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
                confirmHandler()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            viewController.present(alert, animated: true)
        }
    }

