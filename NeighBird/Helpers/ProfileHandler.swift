//
//  ProfileHandler.swift
//  NeighBird
//
//  Created by Sara Nordberg on 23/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct ProfileHandler {
    //    Variables
    var firstName: String?
    var lastName: String?
    var adress: String?
    var zipcode: String?
    var city: String?
    var phoneNumber: String?
    var email: String?
    var imageURL: String?
    var ref: DatabaseReference!
    
    //initialize the variable using a snapshot
    init(snapshot: DataSnapshot){
        ref = snapshot.ref
        
        firstName = (snapshot.value! as! NSDictionary) ["firstName"] as? String
        lastName = (snapshot.value! as! NSDictionary) ["lastName"] as? String
        adress = (snapshot.value! as! NSDictionary) ["address"] as? String
        zipcode = (snapshot.value! as! NSDictionary) ["zipcode"] as? String
        city = (snapshot.value! as! NSDictionary) ["city"] as? String
        phoneNumber = (snapshot.value! as! NSDictionary) ["phoneNumber"] as? String
        email = (snapshot.value! as! NSDictionary) ["email"] as? String
        imageURL = (snapshot.value! as! NSDictionary) ["profilePhotoURL"] as? String
    }
    
    //sets UserDefaults
    func setDefaults(){
        storageRef.reference(forURL: imageURL!).getData(maxSize: 2 * 1024 * 1024, completion: { (photoData, error) in
            if error == nil {
                if let data = photoData {
                    print("done")
                    UserDefaults.standard.set(data, forKey: "picture")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(lastName, forKey: "lastName")
        UserDefaults.standard.set(adress, forKey: "address")
        UserDefaults.standard.set(city, forKey: "city")
        UserDefaults.standard.set(zipcode, forKey: "zipcode")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.set(imageURL, forKey: "imageURL")
        
        UserDefaults.standard.synchronize()
    }
    let userID = Auth.auth().currentUser?.uid
}
