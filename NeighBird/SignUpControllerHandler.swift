//
//  SignUpControllerHandler.swift
//  NeighBird
//
//  Created by Sara Nordberg on 09/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   @objc func handleSelectProfilePhoto() {
        print("hej")
        let picker = UIImagePickerController()
    
    
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("Afbrud picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedPhotoFromPicker: UIImage?
        
        //Vi sætter her vores variable to enten at være editedPhoto eller originalPhoto.
        //Her bliver vi nød til at kaste det til et UIImage med as?
        if let editedPhoto = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedPhotoFromPicker = editedPhoto
        } else if let originalPhoto = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedPhotoFromPicker = originalPhoto
        }
        
        if let selectedPhoto = selectedPhotoFromPicker {
            photo.image = selectedPhotoFromPicker
        }
        dismiss(animated: true, completion: nil)
    }
}
