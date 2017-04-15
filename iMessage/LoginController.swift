//
//  LoginController.swift
//  iMessage
//
//  Created by Mat Schmid on 2017-04-09.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var mesController : MessagesController?
    
    //Inputs container
    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
        
    }()
    
    //Upload Image button
    lazy var uploadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 58, g: 21, b: 128)
        button.setTitle("Upload Profile Image", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleUploadImage), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    //Register/Login button
    lazy var logRegButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 58, g: 21, b: 128)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleLoginOrReg), for: .touchUpInside)
        
        return button
    }()
    
    
    
    func handleLoginOrReg(){
        if loginRegisterSegment.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = PassTextField.text
            else{
                print("Invalid form entry")
                return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, logErr) in
            if logErr != nil {
                print(logErr.debugDescription)
                return
            }
            
            self.mesController?.setupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    
    let nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let PassTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        
        return tf
        
    }()
    
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "feather3")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    let imagePicker: UIImageView = {
        let picker = UIImageView()
        picker.image = UIImage(named: "userPlaceholder")

        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentMode = .scaleAspectFill
        picker.layer.masksToBounds = true
        picker.layer.borderColor = UIColor.black.cgColor
        picker.layer.cornerRadius = 25
        //picker.layer.borderWidth = 1
        //picker.image?.circleMasked
        
        picker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
        picker.isUserInteractionEnabled = true
        return picker
    }()
    
    lazy var loginRegisterSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    func handleSegmentChange() {
        nameTextField.text = ""
        emailTextField.text = ""
        PassTextField.text = ""
        
        uploadImageButton.isHidden = loginRegisterSegment.selectedSegmentIndex == 0 ? true : false
        imagePicker.isHidden = loginRegisterSegment.selectedSegmentIndex == 0 ? true : false
        //logRegButton.topAnchor = loginRegisterSegment.selectedSegmentIndex == 0 ? inputContainerView.bottomAnchor : uploadImage
        
        let title = loginRegisterSegment.titleForSegment(at: loginRegisterSegment.selectedSegmentIndex)
        logRegButton.setTitle(title, for: .normal)
        
        inputContainerHeight?.constant = loginRegisterSegment.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextField.placeholder = loginRegisterSegment.selectedSegmentIndex == 0 ? "" : "Name"
        nameContainerHeight?.isActive = false
        nameContainerHeight = nameTextField.heightAnchor.constraint(equalToConstant: loginRegisterSegment.selectedSegmentIndex == 0 ? 0 : 50)
        nameContainerHeight?.isActive = true
        
        btnConstraint?.isActive = false
        btnConstraint = logRegButton.topAnchor.constraint(equalTo: loginRegisterSegment.selectedSegmentIndex == 0 ? inputContainerView.bottomAnchor : imagePicker.bottomAnchor, constant: 12)
        btnConstraint?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gradient bg
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [UIColor(r: 8, g: 221, b:214).cgColor, UIColor(r:0, g: 125, b:160).cgColor]
        view.layer.addSublayer(gradientLayer)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        
        //instantiating the input viewer
        view.addSubview(inputContainerView)
        view.addSubview(logRegButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegment)
        view.addSubview(uploadImageButton)
        view.addSubview(imagePicker)
        
        
        setupInputContainerView()
        setupLogRegButton()
        setupPorifleImageView()
        setupSegmentControll()
        setupUploadImageButton()
        setupSelectImageView()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setupSegmentControll() {
        
        //Constraints :  need x,y, width and height
        loginRegisterSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegment.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegment.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegment.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
    }
    func setupLabel() {
        
        //Constraints :  need x,y, width and height
        //nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //nameLabel.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        
        
    }
    func setupPorifleImageView() {
        
        
        //Constraints :  need x,y, width and height
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegment.topAnchor, constant: -24).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        
        
    }

    func setupSelectImageView() {
        
        
        //Constraints :  need x,y, width and height
        //imagePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imagePicker.leftAnchor.constraint(equalTo: logRegButton.leftAnchor).isActive = true
        imagePicker.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        imagePicker.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imagePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
    }
    func setupUploadImageButton(){
        
        
        //uploadImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadImageButton.rightAnchor.constraint(equalTo: logRegButton.rightAnchor).isActive = true
        //uploadImageButton.topAnchor.constraint(equalTo: logRegButton.bottomAnchor, constant: 20).isActive = true
        uploadImageButton.centerYAnchor.constraint(equalTo: imagePicker.centerYAnchor).isActive = true
        uploadImageButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -65).isActive = true
        uploadImageButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    var btnConstraint : NSLayoutConstraint?
    func setupLogRegButton(){
        
        //Constraints :  need x,y, width and height
        logRegButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnConstraint = logRegButton.topAnchor.constraint(equalTo: imagePicker.bottomAnchor, constant: 12)
        btnConstraint?.isActive = true
        
        //how wide
        logRegButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        logRegButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    var inputContainerHeight : NSLayoutConstraint?
    var nameContainerHeight  : NSLayoutConstraint?
    var emailContainerHeight  : NSLayoutConstraint?
    var passwordContainerHeight  : NSLayoutConstraint?
    
    func setupInputContainerView() {
        
        //Constraints :  need x,y, width and height
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputContainerHeight = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeight?.isActive = true
        
        
        
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparator)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparator)
        inputContainerView.addSubview(PassTextField)
        
        
        //Constraints :  need x,y, width and height
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameContainerHeight = nameTextField.heightAnchor.constraint(equalToConstant: 50)
        nameContainerHeight?.isActive = true
        
        
        //Constraints :  need x,y, width and height
        nameSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //Constraints :  need x,y, width and height
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailContainerHeight = emailTextField.heightAnchor.constraint(equalToConstant: 50)
        emailContainerHeight?.isActive = true
        
        //Constraints :  need x,y, width and height
        emailSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //Constraints :  need x,y, width and height
        PassTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        PassTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        PassTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        passwordContainerHeight = PassTextField.heightAnchor.constraint(equalToConstant: 50)
        passwordContainerHeight?.isActive = true
        
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
