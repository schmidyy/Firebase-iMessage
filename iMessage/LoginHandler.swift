//
//  LoginHandler.swift
//  iMessage
//
//  Created by Mat Schmid on 2017-04-10.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleUploadImage(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
       
        present(picker, animated: true, completion: nil)
        print(123)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage : UIImage?
        
        if let editedImage = info["UIIMagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        }
        
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }
        
        if let image = selectedImage {
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
