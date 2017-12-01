//
//  TestTableViewController.swift
//  NeighBird
//
//  Created by RHG on 30/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

enum Section: Int {
    case createNewGroupSection = 0
    case currentGroupSection
}

class TestTableViewController: UITableViewController {
    //Properties
    var senderDisplayName: String?
    var NewGroupTextField: UITextField?
    private var groups :[Group] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        groups.append(Group(name: "test1", members: 3, photo: #imageLiteral(resourceName: "Bird"))!)
        groups.append(Group(name: "test2", members: 4, photo: #imageLiteral(resourceName: "Bird"))!)
        groups.append(Group(name: "test3", members: 5, photo: #imageLiteral(resourceName: "Bird"))!)
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewGroupSection:
                return 1
            case .currentGroupSection:
                return groups.count
            }
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewGroupSection.rawValue ? "NewGroup" : "ExistingGroup"
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.currentGroupSection.rawValue {
            cell.textLabel?.text = groups[(indexPath as NSIndexPath).row].name
        }
        // Configure the cell...
            
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

