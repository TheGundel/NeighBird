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
        Database.database().reference().child("groups").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
            }
            
            print(snapshot)
            
            
            
            
            
        }, withCancel: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.backgroundColor = .clear
        
        //load Groups
        loadGroups()
        
        addButton.layer.borderWidth = 4
        addButton.layer.borderColor = UIColor.white.cgColor
        addButton.titleLabel?.baselineAdjustment = .alignCenters
        addButton.clipsToBounds = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let group = groups[indexPath.row]
        // Configure the cell...
        cell.nameLabel.text = group.name

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
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
