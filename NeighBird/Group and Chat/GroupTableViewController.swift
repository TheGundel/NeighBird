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
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBAction func createGroup(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createGroup")
        self.present(vc!, animated: true, completion: nil)
    }
    
    private func loadGroups(){
        groups.removeAll()
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
                    let groupId = value["toId"] as? String
                    let groupRef = Database.database().reference().child("groups").child(groupId!)
                    groupRef.observe(.value, with: { (snapshot) in
                            if let value = snapshot.value as? NSDictionary {
                                let group = Group()
                                let name = value["name"] as? String ?? "Name not found"
                                let owner = value["owner"] as? String ?? "Owner not found"
                                let key = snapshot.key
                                group.name = name
                                group.owner = owner
                                group.key = key
                                if self.groups.contains(group){
                                    return
                                } else {
                                    self.groups.append(group)
                                }
                                self.groups.sort(by: { (group1, group2) -> Bool in
                                    return group1.name! < group2.name!
                                })
                                DispatchQueue.main.async { self.groupTableView.reloadData() }
                            }
                        
                    }, withCancel: nil)
                }
            }, withCancel: nil)
        }, withCancel: nil)
}

    override func viewDidLoad() {
        super.viewDidLoad()
        groups.removeAll()
        self.groupTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.backgroundColor = .clear
        
        //load Groups
        loadGroups()
        
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
        return groups.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GroupTableViewCell  else {
            fatalError("Dequeued cell is not instance of GroupTableViewCell")
        }
        // Configure the cell...
        let group = groups[indexPath.row]
        cell.nameLabel.text = group.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = self.groups[indexPath.row]
        //showChatViewControllerForGroup(group: group)
        
    }
}
