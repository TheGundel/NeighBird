//
//  CreateGroupTableViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 29/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateGroupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var userElements = [UserTableElement]()
    var ref: DatabaseReference! {
        return Database.database().reference()
    }
    
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    func getUsers(){
        let usersRef = ref.child("users")
        usersRef.observe(.value) { (snapshot) in
            let users = UsersHandler(snapshot: snapshot)
            self.userElements = users.getUsersElements()
            self.userTable.dataSource = self
            self.userTable.delegate = self
            
        }
        
    }
    
    func createGroup(){
        self.ref.child("groups").child(NSUUID().uuidString).setValue(["groupName": "\nameLabel.Text!"])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
