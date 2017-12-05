//
//  GroupTableViewCell.swift
//  NeighBird
//
//  Created by Sara Nordberg on 27/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

class GroupTableViewCell: UITableViewCell {
//    Variables
    
    @IBOutlet weak var nameLabel: UILabel!

    var message: Message? {
        didSet {
            // Configure the cell...
            if let toId = message?.toId {
                let ref = Database.database().reference().child("groups").child(toId)
                ref.observe(.value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary{
                        self.nameLabel.text = value["name"] as? String
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
