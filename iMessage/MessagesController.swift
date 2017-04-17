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
    
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        navigationItem.title = nil
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        //observeMessages()
        
    }
    
    var messages = [Message]()
    var messageDictionary = [String:Message]()
    
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("messages").child(messageID)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    message.setValuesForKeys(dictionary)
                    //self.messages.append(message)
                    
                    if let toID = message.toID {
                        self.messageDictionary[toID] = message
                        
                        self.messages = Array(self.messageDictionary.values)
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            return (m1.timestamp?.int32Value)! > (m2.timestamp?.int32Value)!
                        })
                    }
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func observeMessages() {
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                message.setValuesForKeys(dictionary)
                //self.messages.append(message)
                
                if let toID = message.toID {
                    self.messageDictionary[toID] = message
                    
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort(by: { (m1, m2) -> Bool in
                        return (m1.timestamp?.int32Value)! > (m2.timestamp?.int32Value)!
                    })
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let message = self.messages[indexPath.row]
        
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerID = message.chatPartnerID() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerID

            user.email = dictionary["email"] as? String
            user.name = dictionary["name"] as? String
            user.profileImageURL = dictionary["profileImageUrl"] as? String
            //user.setValuesForKeys(dictionary)
            self.showChatController(user: user)
            
        }, withCancel: nil)
        
        
    }
    
    func showChatController(user: User) {
        let controller = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        //navigationController?.pushViewController(controller, animated: true)
        controller.user = user
        let navBar = UINavigationController(rootViewController: controller)
        present(navBar, animated: true, completion: nil)
    }
    
    func handleNewMessage() {
        let newMessagesController = NewMessageController()
        newMessagesController.mes = self
        let navBar = UINavigationController(rootViewController: newMessagesController)
        
        present(navBar, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            setupNavBarTitle()
        }
    }
    
    func setupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dict["name"] as? String
                //self.reloadInputViews()
                
                self.messages.removeAll()
                self.messageDictionary.removeAll()
                self.tableView.reloadData()
                
                self.observeUserMessages()
            }
        }, withCancel: nil)
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutErr{
            print(logoutErr)
        }
        let logginController = LoginController()
        logginController.mesController = self
        present(logginController, animated: true, completion: nil)
    }
}

