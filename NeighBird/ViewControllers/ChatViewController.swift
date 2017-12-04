//
//  ChatViewController.swift
//  NeighBird
//
//  Created by RHG on 02/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UITextFieldDelegate{
    
    var group: Group?
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Skriv besked!"
        textField.backgroundColor = UIColor.clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        members.removeAll()
        collectionView?.backgroundColor = UIColor.lightGray
        setupChatComponents()
        findUsersForGroup()
    }
    
    func setupChatComponents(){
        setupTopComponents()
        setupBottomComponents()
    }
    
    func setupTopComponents(){
        let topContainerView = UIView()
        topContainerView.backgroundColor = UIColor(red:0.98, green:0.93, blue:0.31, alpha:1.0)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topContainerView)
        
        //anchors
        topContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("Tilbage", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(backButton)
        
        //anchors
        backButton.leftAnchor.constraint(equalTo: topContainerView.leftAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor, constant: 8).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.heightAnchor.constraint(equalTo: topContainerView.heightAnchor).isActive = true
        
        backButton.addTarget(self, action: #selector(returnToPreView), for: .touchUpInside)
        
        let chatName = UILabel()
        chatName.text = group?.name
        chatName.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(chatName)
        
        //anchors
        chatName.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
      //  chatName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        chatName.heightAnchor.constraint(equalTo: topContainerView.heightAnchor).isActive = true
        chatName.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor, constant: 8).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.darkGray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(separatorLineView)
        //anchors
        separatorLineView.leftAnchor.constraint(equalTo: topContainerView.leftAnchor).isActive = true
        separatorLineView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: topContainerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    func setupBottomComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //anchors
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = UIColor.yellow
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        //anchors
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        //anchors
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
    }
    
    @objc func sendMessage(){
        print(inputTextField.text!)
        
        if inputTextField.text!.isEmpty{
            return
        } else {
        let ref = Database.database().reference().child("messages").childByAutoId()
        let sender = Auth.auth().currentUser?.uid
        let toId = group!.key!
        let timestamp = Int(NSDate().timeIntervalSince1970) as NSNumber
        //let groupId = sometihing
        let values = ["text": inputTextField.text!, "sender": sender!, "toId": toId, "timestamp": timestamp] as [String : Any]
        ref.updateChildValues(values)
            
            
        let messageRef = Database.database().reference()
        for user in members {
            messageRef.child("user-messages").child(user).updateChildValues([ref.key: 1])
        }
            
        inputTextField.text = ""
        }
    }
    
    @objc func returnToPreView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 1
        self.present(vc, animated: true, completion: nil )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    var members = [String]()
    
    func findUsersForGroup(){
        let groupId = group?.key
        print(groupId)
        let ref = Database.database().reference().child("group-members").child(groupId!)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key as? String
            self.members.append(userId!)
        }, withCancel: nil)
        print(members.count)
    }
}
