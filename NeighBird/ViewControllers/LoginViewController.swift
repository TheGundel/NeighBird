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

func getDocumentsURL() -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL.path
}


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var newUser: UIButton!
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        if self.email.text == "" || self.password.text == "" {
            //Alert user that an error accured
            let alertController = UIAlertController(title: "Login mislykkedes", message: "Indtast email og password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                
                if error == nil {
                    print("Login successful")
                    
                    //Go to home screen if login was successfull
                    
                    loadUserInfo()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    print("FAIL")
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        self.email.delegate = self
        self.password.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        UserDefaults.standard.set(user.adress, forKey: "address")
        UserDefaults.standard.set(user.city, forKey: "city")
        UserDefaults.standard.set(user.zipcode, forKey: "zipcode")
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.phoneNumber, forKey: "phoneNumber")
        
        
        
        
        let photoURL = user.imageURL!
        storageRef.reference(forURL: photoURL).getData(maxSize: 2 * 1024 * 1024, completion: { (photoData, error) in
            
            if error == nil {
                if let data = photoData {
                    UserDefaults.standard.set(data, forKey: "picture")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }) { (error) in
        print (error.localizedDescription)
    }}



