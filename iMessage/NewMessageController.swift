//
//  NewMessageController.swift
//  iMessage
//
//  Created by Mat Schmid on 2017-04-09.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellID = "CellID"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleBack))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        
        
        fetchUserData()
    }
    
    func fetchUserData(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: String]{
                let user = User(dictionary: dict)
                user.id = snapshot.key
                self.users.append(user)
                
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
            }
            
            
        }, withCancel: nil)
    }
    
    func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        
        if let profileImageUrl = user.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        //cell.profileImageView.image = UIImage(named: "userPlaceholder")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var mes : MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.mes?.showChatController(user: user)
        }
    }

}


