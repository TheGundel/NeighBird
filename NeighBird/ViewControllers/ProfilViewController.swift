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
    
    // Variables
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
    
    //Receive user info from UserDefaults
    func getUserInfo(){
        let name = "\(UserDefaults.standard.object(forKey: "firstName")!) \(UserDefaults.standard.object(forKey: "lastName")!)"
        self.name.text = name
        
        adress.text = UserDefaults.standard.object(forKey: "address") as? String
        phoneNumber.text = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        
        if(UserDefaults.standard.object(forKey: "picture") != nil){
        let picture = UIImage(data: UserDefaults.standard.object(forKey: "picture") as! Data)
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
        image.contentMode = .scaleToFill
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserInfo()
    }
}
