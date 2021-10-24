//
//  UIViewControllerExtension.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController{
    func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Alert",
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            self?.present(alert, animated: true)
        }
    }
    func showLoader() {
        DispatchQueue.main.async {
            self.setScreenUserInteraction(isEnabled: false)
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.show()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.setScreenUserInteraction(isEnabled: true)
        }
    }
    func setScreenUserInteraction(isEnabled: Bool) {
        view.isUserInteractionEnabled = isEnabled
        navigationController?.navigationBar.isUserInteractionEnabled = isEnabled
    }
    func addGestureToHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
