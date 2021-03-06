//
//  ViewController.swift
//  Instagram-Clone
//
//  Created by Inam Ahmad-zada on 2018-01-08.
//  Copyright © 2018 Inam Ahmad-zada. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(plusPhotoButtonAction), for: .touchUpInside)
        return view
    }()
    
    let emailTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        view.placeholder = "Email"
        view.addTarget(self, action: #selector(inputTextFieldsTextChanged), for: .editingChanged)
        return view
    }()
    
    let usernameTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        view.placeholder = "Username"
        view.addTarget(self, action: #selector(inputTextFieldsTextChanged), for: .editingChanged)
        return view
    }()
    
    let passwordTextField: UITextField = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        view.placeholder = "Password"
        view.addTarget(self, action: #selector(inputTextFieldsTextChanged), for: .editingChanged)
        return view
    }()
    
    let signUpButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        view.setTitle("Sign up", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        view.layer.cornerRadius = 5
        view.isEnabled = false
        view.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, topPadding: 80, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 50)
    }
    
    func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topPadding: 20, leftPadding: 40, bottomPadding: 0, rightPadding: 40, width: 0, height: 200)
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let view = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 204)]))
        view.setAttributedTitle(attributedString, for: .normal)
        view.addTarget(self, action: #selector(alreadyHaveAccountAction), for: .touchUpInside)
        return view
    }()
    
    @objc
    func alreadyHaveAccountAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func plusPhotoButtonAction() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc
    func inputTextFieldsTextChanged() {
        guard let email = emailTextField.text, let username = usernameTextField.text, let password = passwordTextField.text, email.count > 0, username.count > 0, password.count > 0 else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            return
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 204)
    }
    
    @objc
    func signUpButtonAction() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                print("User creation failed with an error: ", error)
                return
            }
            
            guard let uid = user?.uid else { return }
            
            guard let image = self?.plusPhotoButton.imageView?.image, let imageData = UIImageJPEGRepresentation(image, 0.5) else { return }
            let imageId = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(imageId).putData(imageData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Saving image to the cloud gave an error: ", error)
                    return
                }
                
                guard let imageUrlString = metadata?.downloadURL()?.absoluteString else { return }
                let dictionaryValues = ["username": username, "imageUrl": imageUrlString]
                let values = [uid: dictionaryValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        print("Adding user to database gave an error: ", error)
                        return
                    }
                    
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    self?.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage!
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.size.width / 2
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

