//
//  ResetPasswordViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 09/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    // Variables
    @IBOutlet weak var email: UITextField!
    
    //A IBBAction which using the email textField sends a password reset request to Firebase
    @IBAction func resetPassword(_ sender: UIButton) {
        if self.email.text == "" {
            let alertController = UIAlertController(title: "Fejl", message: "Indtast venligst email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.email.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Fejl"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Email sendt!"
                    message = "Email med nulstilling af adgangskode er afsendt"
                    self.email.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
