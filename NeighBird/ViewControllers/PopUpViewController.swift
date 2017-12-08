//
//  PopUpViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 01/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    // Variables
    @IBOutlet weak var textBox: UILabel!
    @IBOutlet weak var headerText: UILabel!
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
}
