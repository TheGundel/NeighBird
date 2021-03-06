//
//  LoginViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 02/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Photos

func getDocumentsURL() -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL.path
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    // Variables
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var newUser: UIButton!
    
    var indicator = UIActivityIndicatorView()
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        if self.email.text == "" || self.password.text == "" {
            //Alert user to type in email and password
            let alertController = UIAlertController(title: "Login mislykkedes", message: "Indtast email og password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            //Try to log in the user
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                
                if error == nil {
                    //If there is no error, then the user is logged in
                    print("Login successful")
                    self.indicator.transform = CGAffineTransform(scaleX: 3,y: 3)
                    self.indicator.center = self.view.center
                    self.indicator.hidesWhenStopped = true
                    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                    self.view.addSubview(self.indicator)
                    self.indicator.startAnimating()
                    //Go to home screen if login was successfull
                    DispatchQueue.main.async {
                        loadUserInfo()
                        DispatchQueue.main.async {
                            
                        }
                    }
                    self.perform(#selector (self.changeView), with: nil, afterDelay: 2.5)
                } else {
                    //otherwise show the user an alert with the firebare message
                    print("FAIL")
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func changeView(){
        indicator.stopAnimating()
        //Changes view
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.email.delegate = self
        self.password.delegate = self
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

var dataBaseRef: DatabaseReference! {
    return Database.database().reference()
}

var storageRef: Storage {
    return Storage.storage()
}

func loadUserInfo() {
    let userRef = dataBaseRef.child("users").child((Auth.auth().currentUser!.uid))
    userRef.observe(.value, with: {(snapshot) in
        
        let user = ProfileHandler(snapshot: snapshot)
        user.setDefaults()
    }) { (error) in
        print (error.localizedDescription)
    }
}



