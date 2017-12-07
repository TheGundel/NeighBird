//
//  ChatViewController.swift
//  NeighBird
//
//  Created by RHG on 02/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var group: Group?
    var messages = [Message]()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Skriv besked!"
        textField.backgroundColor = UIColor.clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        members.removeAll()
        //set 8 pixels padding in the top and 58 in the bottom to avoid bottom components
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58, 0)
        //padding for scrollbar
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupChatComponents()
        findUsersForGroup()
        observeMessages()
        showAndHideKeyboard()
    }
    
    func showAndHideKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
    }
    
    @objc func handleKeyboardWillHide(notification: Notification){
        containerViewBottomAnchor?.constant = 0
    }
    
    func setupChatComponents(){
        setupTopComponents()
        setupBottomComponents()
    }
    
    func setupTopComponents(){
        let topContainerView = UIView()
        topContainerView.backgroundColor = UIColor(red:254/255, green:237/255, blue:1/255, alpha:1.0)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topContainerView)
        
        //anchors
        topContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalToConstant: 76).isActive = true
        
        let backButton = UIButton(type: .custom)
        //        backButton.setTitle("<", for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "backbtnImage"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        //        backButton.setTitleColor(UIColor .black, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(backButton)
        
        //anchors
        backButton.leftAnchor.constraint(equalTo: topContainerView.leftAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor, constant: 8).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalTo: topContainerView.heightAnchor).isActive = true
        
        backButton.addTarget(self, action: #selector(returnToPreView), for: .touchUpInside)
        
        let chatName = UILabel()
        chatName.text = group?.name
        
        chatName.font = chatName.font.withSize(20)
        chatName.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(chatName)
        
        //anchors
        chatName.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        //  chatName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        chatName.heightAnchor.constraint(equalTo: topContainerView.heightAnchor).isActive = true
        chatName.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor, constant: 8).isActive = true
        
        collectionView?.topAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupBottomComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //anchors
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .custom)
        //        sendButton.setTitle("Send", for: .normal)
        //        sendButton.backgroundColor = UIColor.yellow
        sendButton.setImage(#imageLiteral(resourceName: "sendButtonImage"), for: .normal)
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
        
        collectionView?.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
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
            let values = ["text": inputTextField.text!, "senderId": sender!, "toId": toId, "timestamp": timestamp, "isAlert": "N"] as [String : Any]
            ref.updateChildValues(values)
            
            
            let messageRef = Database.database().reference()
            for user in members {
                messageRef.child("user-messages").child(user).updateChildValues([ref.key: 1])
            }
            
            inputTextField.text = ""
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message){
        if message.senderId == Auth.auth().currentUser?.uid{
            cell.textView.textColor = UIColor.black
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
            
        } else {
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        if message.isAlert == "Y" {
            cell.bubbleView.backgroundColor = UIColor(red:254/255, green:237/255, blue:1/255, alpha:1.0)
            cell.textView.textColor = UIColor.black
            cell.textView.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 70
        
        //get estimated size required for the text to fit
        if let text = messages[indexPath.item].text {
            //+20 as the frame needs a few pixels extra
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect{
        //width matches cell width and height needs to be large
        //so we have some room to work with
        let size = CGSize(width: 200, height:1500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        //Font must match cell font
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
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
        let ref = Database.database().reference().child("group-members").child(groupId!)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            self.members.append(userId)
        }, withCancel: nil)
    }
    
    func observeMessages(){
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessageRef = Database.database().reference().child("user-messages").child(userId)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary{
                    let message = Message()
                    message.senderId = value["senderId"] as? String
                    message.toId = value["toId"] as? String
                    message.text = value["text"] as? String
                    message.timestamp = value["timestamp"] as? NSNumber
                    message.isAlert = value["isAlert"] as? String
                    
                    if message.toId == self.group?.key{
                        self.messages.append(message)
                        DispatchQueue.main.async { self.collectionView?.reloadData() }
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
}
