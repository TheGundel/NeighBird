//
//  AlertViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 01/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

class AlertViewController: UIViewController, SlideToControlDelegate {
    
    @IBOutlet var messageButtons: [UIButton]!
    @IBOutlet weak var alertButton: SlideToControl!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func selectionHandler(_ sender: UIButton) {
        messageButtons.forEach { (button) in
            UIView.animate(withDuration: 0.5, animations: {
                button.isHidden = !button.isHidden
                self.view.bringSubview(toFront: self.stackView)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func messageTap(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            let text = sender.titleLabel?.text
            topButton.setTitle(text, for: .normal)
        default:
            break
        }
        selectionHandler(sender)
    }
    
    func sliderCameToEnd() {
        
        if topButton.titleLabel?.text == "Vælg besked" || button.titleLabel?.text == "Vælg gruppe" {
            let alert: UIAlertController = UIAlertController(title: "Fejl", message: "Vælg både besked og gruppe", preferredStyle: .alert)
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
        } else {
            
            let groupId = button.dropView.selectedGroup.key
            sendAlertMessage(groupId: groupId!, alertMessage: (topButton.titleLabel?.text)!)
            let alert: UIAlertController = UIAlertController(title: "Alert afsendt", message: "Din gruppe er notificeret", preferredStyle: .alert)
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        alertButton.setThumbViewX()
    }
    
    func loadGroups(){
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
                    self.button.dropView.groups.append(group)
                    DispatchQueue.main.async {self.button.dropView.tableView.reloadData() }
                }
            }
        }
        
    }
    
    func sendAlertMessage(groupId: String, alertMessage: String){
        let senderId = Auth.auth().currentUser?.uid
        let timestamp = Int(NSDate().timeIntervalSince1970) as NSNumber
        let alertRef = Database.database().reference().child("messages")
        let child = alertRef.childByAutoId()
        child.setValue(["senderId": senderId!, "text": alertMessage, "timestamp": timestamp, "toId": groupId, "isAlert": "Y"])
        
        let messageRef = Database.database().reference()
        print(button.dropView.members.count)
        for user in button.dropView.members {
            messageRef.child("user-messages").child(user).updateChildValues([child.key: 1])
        }
    }
    
    override func viewDidLoad() {
        alertButton.labelText = "Alarmer NeighBirds"
        alertButton.backgroundColor = .clear
        alertButton.delegate = self
        
        button = dropDownButton.init(frame: CGRect(x:0, y:0, width:0, height:0))
        button.setTitle("Vælg gruppe", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor .black, for: .normal)
        button.backgroundColor = UIColor.white
        
        self.view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        let width = topButton.frame.size.width
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        let height = topButton.frame.size.height
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        loadGroups()
        
    }
    var button = dropDownButton()
}

protocol dropDownProtocol {
    func dropDownPressed(string: String)
}

class dropDownButton: UIButton, dropDownProtocol{
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropView = dropDownView.init(frame: CGRect(x:0, y:0, width:0, height:0))
        dropView.delegate = self
        
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        //self.superview?.bringSubview(toFront: dropView)
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150{
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            dismissDropDown()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissDropDown(){
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
            
        }, completion: nil)
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var groups = [Group]()    
    var tableView = UITableView()
    
    var delegate: dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return options.count
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        let group = groups[indexPath.row]
        cell.textLabel?.text = group.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        selectedGroup = group
        findUsersForGroup(groupId: group.key!)
        
        self.delegate.dropDownPressed(string: group.name!)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    var members = [String]()
    var selectedGroup = Group()
    
    func findUsersForGroup(groupId: String){
        members.removeAll()
        let ref = Database.database().reference().child("group-members").child(groupId)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            self.members.append(userId)
        }, withCancel: nil)
    }
}
