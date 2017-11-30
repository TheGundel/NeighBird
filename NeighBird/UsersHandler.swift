//
//  UsersHandler.swift
//  NeighBird
//
//  Created by Sara Nordberg on 29/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import Firebase
import FirebaseDatabase

struct UsersHandler {
    
    var users = [UserTableElement]()
    var ref: DatabaseReference
    
    init(snapshot: DataSnapshot){
        ref = snapshot.ref
        let enumerator = snapshot.children
        
        while let rest = enumerator.nextObject() as? DataSnapshot {
            
            
            let firstName = (rest.value! as! NSDictionary) ["firstName"] as? String
            let lastName = (rest.value! as! NSDictionary) ["lastName"] as? String
            let address = (rest.value! as! NSDictionary) ["address"] as? String
            let userID = rest.key
            
            let fullName = firstName! + " " + lastName!
            
            if userID == Auth.auth().currentUser?.uid{
                break
            }
            
            if !(address?.isEmpty)!{
                let user = UserTableElement(name: fullName, address: address!, userID: userID)
                users.append(user!)
            }
            
            
        }
    }
    
    func getUsersElements() -> [UserTableElement]{
        return users
    }
}
