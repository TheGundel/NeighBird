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
import Photos


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var indicator = UIActivityIndicatorView()
    @IBAction func saveChanges(_ sender: UIButton) {
        indicator.transform = CGAffineTransform(scaleX: 3,y: 3)
        self.indicator.center = self.view.center
        self.indicator.hidesWhenStopped = true
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.indicator)
        self.indicator.startAnimating()
        //Go to home screen if login was successfull
        DispatchQueue.main.async {
            self.updateUserInfo()
        }
        self.perform(#selector (self.changeView), with: nil, afterDelay: 3.0)
    }
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }
    
    @objc func changeView(){
        //Changes view
        indicator.stopAnimating()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil)
    }
    
    func loadUserInfo() {
        firstName.text = UserDefaults.standard.object(forKey: "firstName") as? String
        lastName.text = UserDefaults.standard.object(forKey: "lastName") as? String
        address.text = UserDefaults.standard.object(forKey: "address") as? String
        zipcode.text = UserDefaults.standard.object(forKey: "zipcode") as? String
        City.text = UserDefaults.standard.object(forKey: "city") as? String
        phoneNumber.text = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        email.text = UserDefaults.standard.object(forKey: "email") as? String
        
        if selectedPhotoFromPicker == nil {
            if let picture = UIImage(data: UserDefaults.standard.object(forKey: "picture") as! Data){
                image.image = picture
            }
        }
    }

    func updateUserInfo(){
        if(self.firstName.text!.isEmpty || self.lastName.text!.isEmpty || self.zipcode.text!.isEmpty || self.address.text!.isEmpty || self.City.text!.isEmpty || self.phoneNumber.text!.isEmpty || self.email.text!.isEmpty){
            
            let alertComtroller = UIAlertController(title: "Fejl", message: "Udfyld venligst alle felter", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertComtroller.addAction(defaultAction)
            
            present(alertComtroller, animated: true, completion: nil)
            
        } else {
            let photoName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(photoName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.image.image!) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    //Check hvis der sker en fejl ved upload
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profilePhotoUurl = metadata?.downloadURL()?.absoluteString {
                        let userRef = self.dataBaseRef.child("users").child((Auth.auth().currentUser!.uid))
                        let post = ["firstName": self.firstName.text!, "lastName": self.lastName.text!, "email": self.email.text!, "zipcode": self.zipcode.text!, "address": self.address.text!, "city": self.City.text!, "phoneNumber": self.phoneNumber.text!, "profilePhotoURL": profilePhotoUurl]
                        userRef.updateChildValues(post)
                        self.updateUserDefaults()
                    }
                })
            }
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
        image.contentMode = .scaleToFill
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilePhoto)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadUserInfo()
    }
    
    @objc func handleSelectProfilePhoto() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if authorizationStatus == PHAuthorizationStatus.denied {
            let alertComtroller = UIAlertController(title: "Adgang nægtet", message: "Ops.. Vi har ikke adgang til dine billeder. Gå til indstillinger og giv adgang", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertComtroller.addAction(defaultAction)
            present(alertComtroller, animated: true, completion: nil)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("Afbrud picker")
        dismiss(animated: true, completion: nil)
    }
    
    var selectedPhotoFromPicker: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Vi sætter her vores variable to enten at være editedPhoto eller originalPhoto.
        //Her bliver vi nød til at kaste det til et UIImage med as?
        if let editedPhoto = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedPhotoFromPicker = editedPhoto
        } else if let originalPhoto = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedPhotoFromPicker = originalPhoto
        }
        if let selectedPhoto = selectedPhotoFromPicker {
            image.image = selectedPhoto
        }
        dismiss(animated: true, completion: nil)
    }
}
