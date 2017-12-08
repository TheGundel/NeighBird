//
//  Message.swift
//  NeighBird
//
//  Created by RHG on 02/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit

//Simple message object
class Message: NSObject {
    // Variables
    var senderId: String?
    var text: String?
    var toId: String?
    var timestamp: NSNumber?
    var isAlert: String?
}
