//
//  PreChatViewController.swift
//  NeighBird
//
//  Created by RHG on 02/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PreChatViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {
    
    var groups = [Group]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBAction func changeView(_ sender: UIButton) {
       // showChatViewControllerForGroup(group: <#T##Group#>)()
    }
    private func loadGroups(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("groups").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let group = Group()
                    let name = value["name"] as? String ?? "Name not found"
                    let owner = value["owner"] as? String ?? "Owner not found"
                    let key = child.key
                    group.name = name
                    group.owner = owner
                    group.key = key
                    self.groups.append(group)
                    DispatchQueue.main.async { self.groupTableView.reloadData() }
                }
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PreChatGroupTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PreChatGroupTableViewCell  else {
            fatalError("Dequeued cell is not instance of PreChatGroupTableViewCell")
        }
        // Configure the cell...
        let group = groups[indexPath.row]
        cell.groupNameLabel.text = group.name
        return cell
    }
    
    func showChatViewControllerForGroup(group: Group){
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatViewController.group = group
        self.present(chatViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = self.groups[indexPath.row]
        showChatViewControllerForGroup(group: group)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.backgroundColor = .clear
        
        //load Groups
        loadGroups()
    }
}
