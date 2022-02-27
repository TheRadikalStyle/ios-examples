//
//  SplashScreenViewController.swift
//  OneMe
//
//  Created by David Ochoa on 21/02/22.
//
// https://firebase.google.com/docs/auth/ios/manage-users?authuser=3

import UIKit
import FirebaseAuth

class SplashScreenViewController: UIViewController {
    
    // The handler for the auth state listener, to allow cancelling later.
     var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /// Show the login screen
    func GoToLoginScreen(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        // Call UINavigationController to use it as root container
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
            
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true)
    }
    
    
    /// If logged in, go to app
    func GoToApp(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        // Call UINavigationController to use it as root container
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootNavigationController") as! UINavigationController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true)
    }
    
    
    // LifeCycle events
    override func viewWillAppear(_ animated: Bool) {
        // Handle user data on auth state changed
        // Start auth_listener
        print("Starting auth listener")
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            
            
            // Decode FIR Object from firebase to get user info
            let user = Auth.auth().currentUser
            if let user = user {
                print("Entrando a user")
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
                    print("Email is verified")
                    self.GoToApp()
                }else{
                    print("Go to verification screen")
                    self.GoToLoginScreen()
                }
            }else{
                print("Go to login screen")
                self.GoToLoginScreen()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Detach listener
        Auth.auth().removeStateDidChangeListener(handle!)
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
