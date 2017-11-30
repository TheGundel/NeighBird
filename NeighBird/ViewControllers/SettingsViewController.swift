//
//  SettingsViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 29/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var about: UIButton!
    @IBOutlet weak var help: UIButton!
    
    @IBAction func signOut(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("Log out successfull")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
}

