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
    // Variables
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var about: UIButton!
    @IBOutlet weak var help: UIButton!
    
    //IBAction to show the about pop up
    @IBAction func aboutPopUp(_ sender: UIButton) {
        let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController
        self.addChildViewController(popUpVc)
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParentViewController: self)
        
        popUpVc.headerText.text = "Om NeighBird"
        popUpVc.textBox.numberOfLines = 0
        popUpVc.textBox.text = "Nogle smarte ord omkring Neighbird"
        popUpVc.textBox.sizeToFit()
    }
    
    //IBAction to show the help pop up
    @IBAction func helpPopUp(_ sender: UIButton) {
        let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController
        self.addChildViewController(popUpVc)
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParentViewController: self)
        
        popUpVc.headerText.text = "Hjælp"
        popUpVc.textBox.numberOfLines = 0
        popUpVc.textBox.text = "Nogle kloge ord som kan hjælpe en med at bruge app'en"
        popUpVc.textBox.sizeToFit()
    }
    
    //IBAction to sign the user out using Firebase and then change view to the login screen
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

