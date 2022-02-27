//
//  ExtendendUITextField.swift
//  OneMe
//
//  Created by David Ochoa on 23/02/22.
//

import Foundation
import UIKit

extension UITextField{
    
    /// Show/Hide passwords on fields based on SecureTextEntry value
    /// DEPRECATED - Use enablePasswordToggle
    @objc func ShowHidePasswords(){
        if(self.isSecureTextEntry){
            self.isSecureTextEntry = false
        }else{
            self.isSecureTextEntry = true
        }
    }
    
    /// Validate Email
    ///
    /// - Returns: true if is email valid, false if not
    func isEmailValid() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text)
    }
    
    
    /// Enable the button inside the view
    func enablePasswordToggle(){
        textContentType = .oneTimeCode
        let button = UIButton(type: .custom)
        // Set image
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView(_:)), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    /// Set image for SecureEntry
    ///
    /// - Parameter UIButton
    @objc fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "mdi-eye-close"), for: .normal)
        }else{
            button.setImage(UIImage(named: "mdi-eye-open"), for: .normal)
        }
    }
    
    /// Toggle image on click
    ///
    ///  - Parameter Sender
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
    
    
}

