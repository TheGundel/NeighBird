//
//  SignUpControllerHandler.swift
//  NeighBird
//
//  Created by Sara Nordberg on 09/11/2017.
//  Copyright © 2017 Sara Nordberg. All rights reserved.
//

import UIKit
import Photos

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //First request access to photo library if permission is not determined otherwise perform actions based on permissions
    @objc func handleSelectProfilePhoto() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if authorizationStatus == PHAuthorizationStatus.denied {
            errorMessage()
        }else if authorizationStatus == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization({ (request) in
                if request == PHAuthorizationStatus.denied {
                    self.errorMessage()
                } else {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.allowsEditing = true
                    self.present(picker, animated: true, completion: nil)
                }
            })
        }else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("Afbrud picker")
        dismiss(animated: true, completion: nil)
    }
    
    //sets the image picked by the UIImagePicker
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
            photo.image = selectedPhoto
        }
        dismiss(animated: true, completion: nil)
    }
    
    func errorMessage(){
        let alertComtroller = UIAlertController(title: "Adgang nægtet", message: "Ops.. Vi har ikke adgang til dine billeder. Gå til indstillinger og giv adgang", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertComtroller.addAction(defaultAction)
        present(alertComtroller, animated: true, completion: nil)
    }
}
