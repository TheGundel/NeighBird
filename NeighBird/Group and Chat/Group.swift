//
//  Group.swift
//  NeighBird
//
//  Created by Sara Nordberg on 27/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit

class Group {
    //    Mark: Properties
    
    var name: String
    var members: Int
    var photo: UIImage?
    
    init?(name:String, members: Int, photo: UIImage?) {
        self.name = name
        self.members = members
        self.photo = photo
        
        if(name.isEmpty) {
            return nil
        }
    }
}
