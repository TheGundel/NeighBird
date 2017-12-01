//
//  AlertViewController.swift
//  NeighBird
//
//  Created by Sara Nordberg on 01/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, SlideToControlDelegate {
    
    @IBOutlet var messageButtons: [UIButton]!
    @IBOutlet weak var alertButton: SlideToControl!
    @IBOutlet weak var topButton: UIButton!
    
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
    
    override func viewDidLoad() {
        alertButton.labelText = "Alarmer NeighBirds"
        alertButton.backgroundColor = .clear
        alertButton.delegate = self
    }
}
