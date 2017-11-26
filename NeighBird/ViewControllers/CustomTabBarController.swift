//
//  CustomTabBarController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 25/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CustomTabBarController: UITabBarController {
    
    let middleButton = UIButton.init(type: .custom)
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }
    
    @objc func handleTouchTabbarCenter()
    {
        if let count = self.tabBar.items?.count
        {
            let i = floor(Double(count / 2))
            self.selectedViewController = self.viewControllers?[Int(i)]
        }
    }
    
    func getImage(){
        let userRef = dataBaseRef.child("users").child((Auth.auth().currentUser!.uid))
        userRef.observe(.value, with: {(snapshot) in
            
            let user = ProfileHandler(snapshot: snapshot)
            
            print(user.firstName!)
            
            let photoURL = user.imageURL!
            self.storageRef.reference(forURL: photoURL).getData(maxSize: 2 * 1024 * 1024, completion: { (photoData, error) in
                
                if error == nil {
                    if let data = photoData {
                        self.middleButton.setImage(UIImage(data:data), for: UIControlState.normal)
//                        image = UIImage(data: data)
                        print("The picture is hereeee")
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            
        }) { (error) in
            print (error.localizedDescription)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        middleButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 66, height: 66)
        middleButton.layer.cornerRadius = 32
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupMiddleButton(){
        middleButton.backgroundColor = .black
        middleButton.layer.borderWidth = 4
        middleButton.layer.borderColor = UIColor.white.cgColor
        getImage()
        middleButton.layer.masksToBounds = false
        middleButton.clipsToBounds = true
        middleButton.contentMode = .scaleAspectFit
        
        self.view.insertSubview(middleButton, aboveSubview: self.tabBar)
        self.tabBar.bringSubview(toFront: self.middleButton)
        self.middleButton.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        
    }
    
}
