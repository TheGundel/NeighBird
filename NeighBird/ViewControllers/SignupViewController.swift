//
//  SignupViewController.swift
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

class SignupViewController: UIViewController, SlideToControlDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatpassword: UITextField!
    @IBOutlet weak var slideButton: SlideToControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.borderWidth = 5
        photo.layer.masksToBounds = false
        photo.layer.cornerRadius = photo.frame.height/2
        photo.clipsToBounds = true
        photo.contentMode = .scaleAspectFit
        
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilePhoto)))
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        ref = Database.database().reference()
        
        slideButton.labelText = "Opret bruger"
        slideButton.backgroundColor = .clear

        slideButton.delegate = self
        
        
    }
    
    func sliderCameToEnd(){
        if email.text == "" {
            let alertComtroller = UIAlertController(title: "Fejl", message: "Indtast venligst email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertComtroller.addAction(defaultAction)
            
            present(alertComtroller, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                
                if error == nil {
                    print("Signup successfull")
                    
                    let user = Auth.auth().currentUser!.uid
                    let email = self.email.text
                    let firstName = self.firstName.text
                    let lastName = self.lastName.text
                    let address = self.adress.text
                    let zipcode = self.zipcode.text
                    let city = self.city.text
                    let phoneNumber = self.phoneNumber.text
                    
                    if self.photo.image == nil {
                        self.photo.image = #imageLiteral(resourceName: "Bird")
                    }
                    let photoName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("\(photoName).png")
                    
                    if let uploadData = UIImagePNGRepresentation(self.photo.image!) {
                        
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            //Check hvis der sker en fejl ved upload
                            if error != nil {
                                print(error!)
                                return
                            }
                            print (metadata!)
                            
                            if let profilePhotoUurl = metadata?.downloadURL()?.absoluteString {
                                self.ref.child("users").child("\(user)").setValue(["firstName": "\(firstName!)", "lastName": "\(lastName!)", "email": "\(email!)", "address": "\(address!)", "zipcode": "\(zipcode!)", "city": "\(city!)", "phoneNumber": "\(phoneNumber!)", "profilePhotoURL": profilePhotoUurl])
                            }
                            
                        })
                    }
                            let alert: UIAlertController = UIAlertController(title: "Bruger oprettet", message: "Log nu ind i NeighBird", preferredStyle: .alert)
                            let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                                alert.dismiss(animated: true, completion: nil)
                               
                                //Changes view
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                                self.present(vc!, animated: true, completion: nil)
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
