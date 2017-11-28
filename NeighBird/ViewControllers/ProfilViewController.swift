//
//  ProfilViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 23/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ProfilViewController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
   @IBAction func editProfile(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "editProfile")
        self.present(vc!, animated: true, completion: nil)
    }
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }

//    func loadUserInfo() {
//
//        let userRef = dataBaseRef.child("users").child((Auth.auth().currentUser!.uid))
//        userRef.observe(.value, with: {(snapshot) in
//            
//            let user = ProfileHandler(snapshot: snapshot)
////            self.name.text = user.firstName! + " " + user.lastName!
////            self.adress.text = user.adress! + " - " + user.zipcode! + " " + user.city!
////            self.phoneNumber.text = user.phoneNumber
//            
//            let photoURL = user.imageURL!
//            self.storageRef.reference(forURL: photoURL).getData(maxSize: 2 * 1024 * 1024, completion: { (photoData, error) in
//
//                if error == nil {
//                    if let data = photoData {
//                        self.image.image = UIImage(data: data)
//                    }
//                } else {
//                    print(error!.localizedDescription)
//                }
//            })
//
//        }) { (error) in
//            print (error.localizedDescription)
//        }}
    
    func setUserInfo(){
        let name = "\(UserDefaults.standard.object(forKey: "firstName")!) \(UserDefaults.standard.object(forKey: "lastName")!)"
        self.name.text = name
        
        adress.text = UserDefaults.standard.object(forKey: "address") as? String
        phoneNumber.text = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        
        if let picture = UIImage(data: UserDefaults.standard.object(forKey: "picture") as! Data){
            image.image = picture
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 5
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        loadUserInfo()
        setUserInfo()
    }

}
