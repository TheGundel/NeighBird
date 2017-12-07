//
//  PreChatGroupTableViewCell.swift
//  NeighBird
//
//  Created by RHG on 02/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

class PreChatGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var message: Message? {
        didSet {
            // Configure the cell...
            if let toId = message?.toId {
                let ref = Database.database().reference().child("groups").child(toId)
                ref.observe(.value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary{
                        self.groupNameLabel.text = value["name"] as? String
                    }
                })
            }
            latestMessageLabel.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue{
                let timestampDate = NSDate.init(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                timestampLabel.text = dateFormatter.string(from: timestampDate as Date)
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
