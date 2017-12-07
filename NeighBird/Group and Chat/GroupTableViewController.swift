//
//  GroupTableViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 27/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //    Mark: Properties
    
    var groups = [Group]()
    
    var messages = [Message]()
    var messageDictionary = [String: Message]()
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBAction func createGroup(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createGroup")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func loadUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid
            else {
                return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    let message = Message()
                    let text = value["text"] as? String ?? "Name not found"
                    let toId = value["toId"] as? String ?? "Owner not found"
                    let timestamp = value["timestamp"] as? NSNumber
                    message.text = text
                    message.toId = toId
                    message.timestamp = timestamp
                    if let toId = message.toId{
                        self.messageDictionary[toId] = message
                        self.messages = Array(self.messageDictionary.values)
                    }
                    DispatchQueue.main.async { self.groupTableView.reloadData() }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.backgroundColor = .clear
        
        //load Groups
        loadUserMessages()
        
        //Changes layout of add group button
        addButton.layer.borderWidth = 4
        addButton.layer.borderColor = UIColor.white.cgColor
        addButton.titleLabel?.baselineAdjustment = .alignCenters
        addButton.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GroupTableViewCell  else {
            fatalError("Dequeued cell is not instance of GroupTableViewCell")
        }
        // Configure the cell...
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
}
