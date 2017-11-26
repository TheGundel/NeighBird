//
//  GroupViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 26/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

enum Section: Int {
    case createNewGroupSection = 0
    case currentGroupSelection
}

class GroupViewController: UITableViewController{
    private var groups: [Group] = []
    
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentGroup: Section = Section(rawValue: section) {
            switch currentGroup {
            case .createNewGroupSection:
                return 1
            case .currentGroupSelection:
                return groups.count
            }
        } else {
            return 0
        }
    }    
    
}
