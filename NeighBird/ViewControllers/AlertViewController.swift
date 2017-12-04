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
    
    var dropButton = dropDownBtn()
    
    @IBAction func selectionHandler(_ sender: UIButton) {
        messageButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
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
        let alert: UIAlertController = UIAlertController(title: "Slider", message: "work", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
                    self.dropButton.dropDownView.groups.append(group)
                    DispatchQueue.main.async {self.dropButton.dropDownView.tableView.reloadData() }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        alertButton.labelText = "Alarmer NeighBirds"
        alertButton.backgroundColor = .clear
        alertButton.delegate = self
        
        dropButton = dropDownBtn.init(frame: CGRect(x:0, y:0, width:0, height:0))
        dropButton.translatesAutoresizingMaskIntoConstraints = false
        dropButton.setTitle("Vælg gruppe", for: .normal)
        self.view.addSubview(dropButton)
        
        dropButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dropButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        dropButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dropButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loadGroups()
        
    }
}

protocol dropDownProtocol {
    func dropDownPressed(string: String)
}

class dropDownBtn: UIButton, dropDownProtocol{
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
    }

    
    var dropDownView = dropView()
    
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
        
        dropDownView = dropView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height:0))
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        
        self.superview?.addSubview(dropDownView)
        
        dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor)
        dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        dropDownView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubview(toFront: dropDownView)
        
        dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor)
        dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        dropDownView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
        print("her")
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
        if isOpen == false{
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            if self.dropDownView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropDownView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                print(self.height)
                self.dropDownView.layoutIfNeeded()
                self.dropDownView.center.y = self.dropDownView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropDownView.center.y = self.dropDownView.frame.height / 2
                self.dropDownView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


class dropView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var groups = [Group]()
    var tableView = UITableView()
    var delegate: dropDownProtocol!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        
        
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
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = groups[indexPath.row].name
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(groups[indexPath.row].name!)
    }
    

    
    
    
}
