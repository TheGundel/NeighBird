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
    // Variables
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        middleButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 66, height: 66)
        middleButton.layer.cornerRadius = 32
    }
    
    //Setup the middlebutton to be round and populate with profilepicture
    func setupMiddleButton(){
        middleButton.backgroundColor = .black
        middleButton.layer.borderWidth = 4
        middleButton.layer.borderColor = UIColor.white.cgColor
        
        if(UserDefaults.standard.object(forKey: "picture") != nil){
            let picture = UIImage(data: UserDefaults.standard.object(forKey: "picture") as! Data)
            middleButton.setImage(picture, for: .normal)
        }
        
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
