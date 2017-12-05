//
//  CreateGroupTableViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 29/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateGroupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var userElements = [UserTableElement]()
    var selectedUsers = [String]()
    var ref: DatabaseReference! {
        return Database.database().reference()
    }
    
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var groupNameLabel: UITextField!
    
    @IBAction func createGroupButton(_ sender: UIButton) {
        createGroup()
        changeView()
    }
    @IBAction func Cancel(_ sender: UIButton) {
        changeView()
    }
    func getUsers(){
        let usersRef = ref.child("users")
        usersRef.observe(.value) { (snapshot) in
            let users = UsersHandler(snapshot: snapshot)
            self.userElements = users.getUsersElements()
            self.userTable.dataSource = self
            self.userTable.delegate = self
            DispatchQueue.main.async { self.userTable.reloadData() }
        }
    }
    
    func createGroup(){
        let owner = Auth.auth().currentUser?.uid
        let child = self.ref.child("groups").childByAutoId()
            child.setValue(["name": "\(groupNameLabel.text!)", "owner": "\(owner!)"])
        let welcomeMessage = "Velkommen til min gruppe. Lad os hjælpe hinanden"
        let timestamp = Int(NSDate().timeIntervalSince1970) as NSNumber
        //send welcome message
        let messageChild = ref.child("messages").childByAutoId()
            messageChild.setValue(["senderId": owner!, "text": welcomeMessage, "timestamp": timestamp, "toId": child.key])
        
        for user in selectedUsers {
            ref.child("user-messages").child(user).updateChildValues([messageChild.key: 1])
            ref.child("group-members").child(child.key).updateChildValues([user: 1])
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userElements.removeAll()
        selectedUsers.removeAll()
        print(userElements.count)
        selectedUsers.append((Auth.auth().currentUser?.uid)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userElements.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
            fatalError("Dequeue cell is not instance of UserTableViewCell")
        }

        let user = userElements[indexPath.row]
        // Configure the cell...
        cell.UserLabel.text = user.name
        cell.addressLabel.text = user.address

        return cell
    }
    
    func changeView(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 3
        self.present(vc, animated: true, completion: nil )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userElements[indexPath.row]
        let cell = userTable.cellForRow(at: indexPath)
        
        if selectedUsers.contains(user.userID) {
            var i = 0
            for users in selectedUsers{
                if users == user.userID{
                    selectedUsers.remove(at: i)
                    cell?.backgroundColor = UIColor.white
                } else {
                    i += 1
                }
            }
        } else {
            selectedUsers.append(user.userID)
            cell?.backgroundColor = UIColor.green
        }
        
    }
}
