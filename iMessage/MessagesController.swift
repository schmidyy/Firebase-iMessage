//
//  ViewController.swift
//  iMessage
//
//  Created by Mat Schmid on 2017-04-08.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        navigationItem.title = nil
        
        checkIfUserIsLoggedIn()
    }
    
    func handleNewMessage() {
        let navBar = UINavigationController(rootViewController: NewMessageController())
        present(navBar, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dict["name"] as? String
                    //self.reloadInputViews()
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutErr{
            print(logoutErr)
        }
        
        present(LoginController(), animated: true, completion: nil)
    }
}

