//
//  SignUpViewController.swift
//  OneMe
//
//  Created by David Ochoa on 22/02/22.
//

import UIKit

import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var UITextFieldRegisterEmail: UITextField!
    @IBOutlet weak var UITextFieldRegisterPwd: UITextField!
    @IBOutlet weak var UITextFieldRegisterPwdConfirm: UITextField!
    @IBOutlet weak var UISwitchAgreeDataPrivacy: UISwitch!
    @IBOutlet weak var UILabelDataPrivacyText: UILabel!
    @IBOutlet weak var UILabelDataPrivacyExplanation: UILabel!
    @IBOutlet weak var UIButtonSignUp: UIButton!
    @IBOutlet weak var UIButtonPrivacyWeb: UIButton!
    
    
    // The handler for the auth state listener, to allow cancelling later.
     var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign Up"
        
        // Enable password toggles (Ojitos)
        UITextFieldRegisterPwd.enablePasswordToggle()
        UITextFieldRegisterPwdConfirm.enablePasswordToggle()
        
        // Add change listener for switch
        UISwitchAgreeDataPrivacy.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        // Add text to labels and button about privacy elements
        UILabelDataPrivacyText.text = "Data privacy agreement"
        UILabelDataPrivacyExplanation.text = "By checking this switch, you agree with our data privacy"
        UIButtonPrivacyWeb.setTitle("Visit data privacy", for: .normal)
        
        // Disable button events
        UIButtonSignUp.isUserInteractionEnabled = false
        UIButtonSignUp.isEnabled = false
    }
    

    
    /// Handle Sign-Up button click
    @IBAction func touchedSignUpButton(_ sender: Any) {
        let email = UITextFieldRegisterEmail.text
        let passwd = UITextFieldRegisterPwd.text
        let passwdConfirm = UITextFieldRegisterPwdConfirm.text
        
        if(ValidateForm(email: email!, password: passwd!, confirmPassword :passwdConfirm!)){
            print("Try sign-up")
            PerformUserRegistration(email: email!, pwd: passwd!)
        }
    }
    
    
    /// Handle privacy button click, open the DataPrivacy URL in default browser
    @IBAction func touchedVisitWebDataPrivacyButton(_ sender: Any) {
        let url = URL(string: "https://www.lipsum.com/feed/html")
        UIApplication.shared.open(url!)
    }
    
    
    /// Validate form
    private func ValidateForm(email :String, password :String, confirmPassword :String) -> Bool{
        // Validate email
        if(!UITextFieldRegisterEmail.isEmailValid()){
            self.showToast(message: "Insert a valid email")
            return false
        }
        
        // Validate password
        if(password.isEmpty){
            self.showToast(message: "Password can't be empty")
            return false
        }
        
        // Validate password confirmation
        if(confirmPassword.isEmpty){
            self.showToast(message: "Please, re-type your password")
            return false
        }
        
        if(password != confirmPassword){
            self.showToast(message: "Passwords not match")
            return false
        }

        return true
    }
    
    
    /// Handle Sign Up Button
    private func PerformUserRegistration(email :String, pwd :String){
        // Create an user using firebase
        Auth.auth().createUser(withEmail: email, password: pwd) { authResult, error in
          // ..
        if let err = error{
            self.showSimpleAlert(title: "SignUp error", message: err.localizedDescription, shouldReturnToRoot: false)
        }else{
            // Account created
            // Send verification email
            Auth.auth().currentUser?.sendEmailVerification {
                error in
                
                if let err = error{
                    
                    self.showSimpleAlert(title: "Error",message: "Email verification not send: \(err.localizedDescription)", shouldReturnToRoot: true)
                }else{
                    self.showSimpleAlert(title: "Congratulations", message: "Account succesfully created, we sent you an email with verification steps, please verify and login.", shouldReturnToRoot: true)
                }
            }
        }
    }
}
    
    /// Listen to switch states
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        if(value){
            // Switch is checked
            UIButtonSignUp.isUserInteractionEnabled = true
            UIButtonSignUp.isEnabled = true
        }else{
            // Switch is unchecked
            UIButtonSignUp.isUserInteractionEnabled = false
            UIButtonSignUp.isEnabled = false
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
