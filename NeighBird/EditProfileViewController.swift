//
//  EditProfileViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 23/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


class EditProfileViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var City: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func saveChanges(_ sender: UIButton) {
        self.updateUserInfo()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.present(vc!, animated: true, completion: nil)
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
            self.firstName.text = user.firstName!
            self.lastName.text = user.lastName!
            self.zipcode.text = user.zipcode!
            self.address.text = user.adress!
            self.City.text = user.city!
            self.phoneNumber.text = user.phoneNumber!
            self.email.text = user.email!
            
            let photoURL = user.imageURL!
            self.storageRef.reference(forURL: photoURL).getData(maxSize: 2 * 1024 * 1024, completion: { (photoData, error) in
                
                if error == nil {
                    if let data = photoData {
                        self.image.image = UIImage(data: data)
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            
        }) { (error) in
            print (error.localizedDescription)
        }}
    
    func updateUserInfo(){
        if(self.firstName.text!.isEmpty || self.lastName.text!.isEmpty || self.zipcode.text!.isEmpty || self.address.text!.isEmpty || self.City.text!.isEmpty || self.phoneNumber.text!.isEmpty || self.email.text!.isEmpty){
            
            let alertComtroller = UIAlertController(title: "Fejl", message: "Udfyld venligst alle felter", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertComtroller.addAction(defaultAction)
            
            present(alertComtroller, animated: true, completion: nil)
            
        } else {
            let userRef = dataBaseRef.child("users").child((Auth.auth().currentUser!.uid))
        let post = ["firstName": self.firstName.text!, "lastName": self.lastName.text!, "email": self.email.text!, "zipcode": self.zipcode.text!, "address": self.address.text!, "city": self.City.text!, "phoneNumber": self.phoneNumber.text!]
        userRef.updateChildValues(post)
        }
    }
    
    
//    func fillFieldsWithInfo() {
  //      Handler.getUserInformation(Handler.userID)
    //    self.firstNameTextField.text = Handler.firstName
      //  self.lastNameTextField.text = Handler.lastName
       
        //self.cityTextField.text = Handler.city
   //     self.emailTextField.text = Handler.email
   //     self.zipcodeTextField.text = Handler.zipcode
   //     self.phoneNumberTextField.text = Handler.phoneNumber
  //  }
    
    override func viewDidLoad() {
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 5
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadUserInfo()
     //   self.fillFieldsWithInfo()
    }
}
