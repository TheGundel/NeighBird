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
    
    var firstName: String?
    var lastName: String?
    var adress: String?
    var zipcode: String?
    var city: String?
    var phoneNumber: String?
    var email: String?
    var imageURL: String?
    var ref: DatabaseReference!
    
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

    let userID = Auth.auth().currentUser?.uid
}
