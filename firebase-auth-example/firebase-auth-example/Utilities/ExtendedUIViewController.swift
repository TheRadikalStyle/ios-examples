//
//  ExtendedUIController.swift
//  OneMe
//
//  Created by David Ochoa on 24/02/22.
//

import Foundation
import UIKit

extension UIViewController{
    
    
    /// Show a toast like android style
    ///
    /// - Parameter message: The text you like to show
    func showToast(message : String) { //font: UIFont
        
        let font = UIFont.systemFont(ofSize: 12.0)

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    /// Show and AlertView with one action attached
    ///
    /// - Parameter title: The title to display
    /// - Parameter message: The message to display
    /// - Parameter behaviourOnClose: An action to execute at close time
    /// - Warning: Behaviour can be nil
    func showSimpleAlert(title :String, message :String, shouldReturnToRoot :Bool){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var closeAction :UIAlertAction
        
        if(shouldReturnToRoot){
            closeAction = UIAlertAction.init(title: "Ok", style: .default) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            closeAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        }
        
        ac.addAction(closeAction)
        
        present(ac, animated: true, completion: nil)
    }
}
