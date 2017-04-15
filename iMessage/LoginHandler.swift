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
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = PassTextField.text, let name = nameTextField.text
            else{
                print("Invalid form entry")
                return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //auth sucsesful
            let imageID = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_image").child("\(imageID).jpg")
            if let profileImage = self.imagePicker.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    
                    if let imageURL = metadata?.downloadURL()?.absoluteString{
                    
                        let values = ["name": name, "email": email, "profileImageUrl": imageURL]
                        self.registerUser(uid: uid, values: values as [String : AnyObject])
                        
                        
                    }
                    
                })
            }
            

            
        })
    }
    
    private func registerUser(uid: String, values: [String: AnyObject]){
        let ref = FIRDatabase.database().reference(fromURL: "https://realtime-imessage.firebaseio.com/")
        //database structure /users/UID/[name, email]
        let userRef = ref.child("users").child(uid)
        //data to be passed in
        
        
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err.debugDescription)
                
                return
            }
            //self.mesController?.setupNavBarTitle()
            self.mesController?.navigationItem.title! = values["name"] as! String
            self.dismiss(animated: true , completion: nil)
        })
    }
    
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
            imagePicker.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
