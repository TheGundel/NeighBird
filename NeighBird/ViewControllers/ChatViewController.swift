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
        collectionView?.backgroundColor = UIColor.lightGray
        setupChatComponents()
    }
    
    func setupChatComponents(){
        setupTopComponents()
        setupBottomComponents()
    }
    
    func setupTopComponents(){
        let topContainerView = UIView()
        topContainerView.backgroundColor = UIColor.yellow
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topContainerView)
        
        //anchors
        topContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("Tilbage", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(backButton)
        
        //anchors
        backButton.leftAnchor.constraint(equalTo: topContainerView.leftAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.heightAnchor.constraint(equalTo: topContainerView.heightAnchor).isActive = true
        
        let chatName = UILabel()
        chatName.text = "Chat titel"
        chatName.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(chatName)
        
        //anchors
        chatName.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        chatName.widthAnchor.constraint(equalToConstant: 80).isActive = true
        chatName.heightAnchor.constraint(equalTo: topContainerView.heightAnchor).isActive = true
        chatName.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        
        
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
        
        let ref = Database.database().reference().child("messages").childByAutoId()
        let sender = Auth.auth().currentUser?.uid
        
        //let groupId = sometihing
        let values = ["text": inputTextField.text!, "sender": sender!]
        ref.updateChildValues(values)
        
        inputTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
