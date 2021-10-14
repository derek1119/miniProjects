//
//  SignUpViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/13.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    let plusPhotoButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "plus_photo")!.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    let emailTextField = UITextField().then {
        $0.placeholder = "Email"
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 14)
        $0.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 14)
        $0.isSecureTextEntry = true
        $0.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    
    let fullNameTextField = UITextField().then {
        $0.placeholder = "Full Name"
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 14)
        $0.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    
    let userNameTextField = UITextField().then {
        $0.placeholder = "User Name"
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 14)
        $0.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    
    let signUpButton = UIButton(type: .system).then {
        $0.setTitle("Sign Up", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    let alreadyHaveAccountButton = UIButton(type: .system).then {
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        $0.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background Color
        view.backgroundColor = .white
        
        setUpConstraints()
    }
    
    @objc func handleShowLogin() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in

            // handle error
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            // success
            print("Successfully create User")
        }
    }
    
    @objc func formValidation() {
        guard
            emailTextField.hasText,
            passwordTextField.hasText,
            fullNameTextField.hasText,
            userNameTextField.hasText
        else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
}

extension SignUpViewController {
    private func setUpConstraints() {
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top).offset(40)
            make.width.height.equalTo(140)
            make.centerX.equalToSuperview()
        }
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signUpButton]).then { stackView in
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fillEqually
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeArea.leading).offset(20)
            make.trailing.equalTo(view.safeArea.trailing).offset(-20)
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(40)
            make.height.equalTo(240)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

