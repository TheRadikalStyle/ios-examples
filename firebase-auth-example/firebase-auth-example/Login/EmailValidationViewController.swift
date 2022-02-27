//
//  EmailValidationViewController.swift
//  OneMe
//
//  Created by David Ochoa on 24/02/22.
//

import UIKit
import FirebaseAuth

class EmailValidationViewController: UIViewController {
    
    // Get the user email as param from login controller
    var userEmail :String?
    
    @IBOutlet weak var labelText: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(userEmail != nil){
            labelText.text = "Hey, looks like you don't verify your email yet.\n An email has been sent to \(userEmail ?? ""), please check your SPAM folder.";
        }else{
            labelText.text = "And error ocurred, please sign out and login again."
        }
    }

    /// Handle resend button
    @IBAction func touchedResendConfimationButton(_ sender: Any) {
        
        // Resend email verification using firebase
        Auth.auth().currentUser?.sendEmailVerification {
            error in
            
            if let err = error{
                self.showSimpleAlert(title: "Error", message: "Email verification not send: \(err.localizedDescription)", shouldReturnToRoot: false)
            }else{
                self.showSimpleAlert(title: "Sent", message: "Email verification sent, check your email", shouldReturnToRoot: false)
            }
        }
    }
    
    
    /// Perform the sign out using firebase
    func SignOut(){
        // Ok bye, log out
        
        let firebaseAuth = Auth.auth()
        do {
            print("Performing sign out")
          try firebaseAuth.signOut()
            
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
    // On dissapear event, perform sign out
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.SignOut()
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
