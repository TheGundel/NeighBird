//
//  ErrorHandler.swift
//  NeighBird
//
//  Created by Sara Nordberg on 03/12/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit

struct ErrorHandler {
    var emptyFields: Int
    
    init() {
        emptyFields = 0
    }
    
    //Check array of UITextFields for textFields that might be empty. If more than 1 is empty show an error
    mutating func isMultipleFieldsEmpty(uiTextFieldArray: [UITextField], message: String, parentView: UIViewController) -> Bool{
        emptyFields = 0
        for element in uiTextFieldArray{
            if element.text!.isEmpty{
                emptyFields += 1
                if(emptyFields >= 2) {
                    let alertComtroller = UIAlertController(title: "Fejl", message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertComtroller.addAction(defaultAction)
                    
                    parentView.present(alertComtroller, animated: true, completion: nil)
                    return true
                }
            }
        }
        return false
    }
    
    //Check if a textField is empty and show an error if it is
    func textFieldIsEmpty(message: String, parentView: UIViewController) {
        let alertComtroller = UIAlertController(title: "Fejl", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertComtroller.addAction(defaultAction)
        
        parentView.present(alertComtroller, animated: true, completion: nil)
    }
    
    //Check if two UITextFields text match
    func textFieldMatch(uiTextField1: UITextField, uiTextField2: UITextField, message: String, parentView: UIViewController) -> Bool{
        if(uiTextField1.text != uiTextField2.text) {
            let alertComtroller = UIAlertController(title: "Fejl", message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertComtroller.addAction(defaultAction)
            
            parentView.present(alertComtroller, animated: true, completion: nil)
            return true
        }
        return false
    }
}
