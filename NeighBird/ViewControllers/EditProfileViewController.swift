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
    
    @IBAction func cancelEdit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil )
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        self.updateUserInfo()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil)
        
        
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "profile") as! UITabBarController
//        self.present(tabbarVC, animated: true, completion: nil)
        
    }
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }
    
    func loadUserInfo() {
        firstName.text = UserDefaults.standard.object(forKey: "firstName") as? String
        lastName.text = UserDefaults.standard.object(forKey: "lastName") as? String
        address.text = UserDefaults.standard.object(forKey: "address") as? String
        zipcode.text = UserDefaults.standard.object(forKey: "zipcode") as? String
        City.text = UserDefaults.standard.object(forKey: "city") as? String
        phoneNumber.text = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        email.text = UserDefaults.standard.object(forKey: "email") as? String
        
        if let picture = UIImage(data: UserDefaults.standard.object(forKey: "picture") as! Data){
            image.image = picture
        }
        
        
    }

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
            self.updateUserDefaults()
            
            
        }
    }
    
    
    func updateUserDefaults(){
        let userRef = dataBaseRef.child("users").child((Auth.auth().currentUser!.uid))
        userRef.observe(.value, with: {(snapshot) in
            
            let user = ProfileHandler(snapshot: snapshot)
            user.setDefaults()
        }) { (error) in
            print (error.localizedDescription)
        }
    }
    
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
    }
}
