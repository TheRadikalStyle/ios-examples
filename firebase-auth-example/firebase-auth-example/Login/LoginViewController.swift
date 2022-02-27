//
//  LoginViewController.swift
//  OneMe
//
//  Created by David Ochoa on 21/02/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // Textfields
    @IBOutlet weak var loginEmailUITextField: UITextField!
    @IBOutlet weak var loginPasswordUITextField: UITextField!
    
    // Buttons
    @IBOutlet weak var loginSignInButton: UIButton!
    @IBOutlet weak var loginForgotPwdButton: UIButton!
    @IBOutlet weak var loginCreateAccountButton: UIButton!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Enable password toggles (Ojitos)
        loginPasswordUITextField.enablePasswordToggle()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    /// Handle Sign-In button click
    
    @IBAction func touchedSignInButton(_ sender: Any) {
        let user = loginEmailUITextField.text
        let password = loginPasswordUITextField.text
        
        
        if(ValidateForm(user: user!, password: password!)){
            Auth.auth().signIn(withEmail: user!, password: password!) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
              // ...
                
                if(error != nil){
                    self?.showSimpleAlert(title: "Error", message: error!.localizedDescription, shouldReturnToRoot: false)
                }else{
                    if let user = authResult?.user {
                      // The user's ID, unique to the Firebase project.
                      // Do NOT use this value to authenticate with your backend server,
                      // if you have one. Use getTokenWithCompletion:completion: instead.
                      //let uid = user.uid
                      //let email = user.email
                      //let isEmailVerified = user.isEmailVerified
                      let photoURL = user.photoURL
                      var multiFactorString = "MultiFactor: "
                      for info in user.multiFactor.enrolledFactors {
                        multiFactorString += info.displayName ?? "[DispayName]"
                        multiFactorString += " "
                      }
                                        
                        if(user.isEmailVerified){
                            self?.GoToApp()
                        }else{
                            self?.GoToVerificationScreen(userEmail: user.email ?? "N/A")
                        }
                    }else{
                        //self?.showToast(message: "An error ocurred, please try again")
                        self?.showSimpleAlert(title: "Error", message: "An error ocurred, please try again", shouldReturnToRoot: false)
                    }
                }
            }
        }
    }
    
    /// Handle Forgot Password button click
    @IBAction func touchedForgotPwdButton(_ sender: Any) {
        self.ShowRecoverPasswordAlert()
    }
    
     /// Handle Create Account button click
    @IBAction func touchedCreateAccountButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "screenSignUp") as! SignUpViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
     /// Validate form
    private func ValidateForm(user :String, password :String) -> Bool{
        // Validate email
        if(!loginEmailUITextField.isEmailValid()){
            self.showToast(message: "Insert a valid email")
            return false
        }
        
        if(password.isEmpty){
            self.showToast(message: "Password can't be empty")
            return false
        }
        
        return true
    }
    
    /// Go to App
    func GoToApp(){
        // Go to screen
        print("ENTRAMOS A APP")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        // Call UINavigationController to use it as root container
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootNavigationController") as! UINavigationController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true)
    }
    
    func GoToVerificationScreen(userEmail :String){
        // User has not verified yet - You shall not pass
        
        let backItem = UIBarButtonItem.init(title: "Log Out", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "screenEmailValidation") as! EmailValidationViewController
    
        // Set params
        nextViewController.userEmail = userEmail
                
        // Show view
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    /// Show dialog for recovery password
    private func ShowRecoverPasswordAlert(){
        let alert = UIAlertController.init(
            title: "Recover password",
            message: "Please, insert the email that you register on the app",
            preferredStyle: .alert
        )
        
        // Attach a textfield to dialog
        alert.addTextField{ (emailTextField) in
            emailTextField.keyboardType = .emailAddress
        }
        
        // Attach an action to dialog
        let okAction = UIAlertAction(title: "Send email", style: .default) { [unowned alert] (action) in
            if let textField = alert.textFields?.first {
                
                // Check if email is valid
                if(textField.isEmailValid()){
                    
                    // If is valid, send a recovery password using firebase
                    Auth.auth().sendPasswordReset(withEmail: textField.text!) { error in
                      // ...
                        if let err = error{
                            self.showSimpleAlert(title: "Error", message: "Email verification not send: \(err.localizedDescription)", shouldReturnToRoot: false)
                        }else{
                            self.showSimpleAlert(title: "Sent", message: "Email verification sent, check your email", shouldReturnToRoot: false)
                        }
                    }
                }else{
                    // If email is not valid
                    // Dismiss email dialog and show a dialog explaining error on input
                    alert.dismiss(animated: true, completion: nil)
                    let alertInvalidEmail = UIAlertController.init(
                        title: "Error",
                        message: "Insert a valid email",
                        preferredStyle: .alert
                    )
                    let actionOkInvalidEmail = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                    alertInvalidEmail.addAction(actionOkInvalidEmail)
                    self.present(alertInvalidEmail, animated: true, completion: nil)
                }
                
                print(textField.text ?? "Nothing entered")
            }
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive) { (alertAction) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }

}
