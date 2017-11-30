//
//  UserTableElement.swift
//  NeighBird
//
//  Created by Sara Nordberg on 29/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit

class UserTableElement {
    //    Mark: Properties
    
    var name: String
    var address: String
    var userID: String
    
    init?(name:String, address:String, userID: String) {
        self.name = name
        self.address = address
        self.userID = userID
        if(name.isEmpty) {
            return nil
        }
    }
}

