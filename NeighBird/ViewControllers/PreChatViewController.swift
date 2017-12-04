//
//  PreChatViewController.swift
//  NeighBird
//
//  Created by RHG on 02/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

class PreChatViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {

    var messages = [Message]()
    var messageDictionary = [String: Message]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PreChatGroupTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PreChatGroupTableViewCell  else {
            fatalError("Dequeued cell is not instance of PreChatGroupTableViewCell")
        }
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    func showChatViewControllerForGroup(group: Group){
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatViewController.group = group
        self.present(chatViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messages[indexPath.row]
        
        if let toId = message.toId {
            let ref = Database.database().reference().child("groups").child(toId)
            ref.observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary{
                    let group = Group()
                    
                    let groupName = value["name"] as? String
                    let owner = value["owner"] as? String
                    let key = snapshot.key
                    group.name = groupName
                    group.owner = owner
                    group.key = key
                    self.showChatViewControllerForGroup(group: group)
                }
            })
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.backgroundColor = .clear

        observeMessages()
    }
    
    func observeMessages() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("messages").queryOrdered(byChild: "toId")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
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
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return true
                            //return message1.timestamp?.intValue > message2.timestamp?.intValue
                        })

                    }
                    DispatchQueue.main.async { self.groupTableView.reloadData() }
                }
            }
        }
        }
        
}

