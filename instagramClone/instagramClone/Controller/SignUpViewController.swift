//
//  SignUpViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/13.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate {

    var imageSelected = false
    
    let plusPhotoButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "plus_photo")!.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
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
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in

            // handle error
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            // set profile Image
            guard let profileImage = self.plusPhotoButton.imageView?.image else { return }
            
            // upload data
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            
            // 파이어베이스 저장소에 이미지 두기
                        // 나중에 이미지를 불러오기 위한 고유의(unique) identifier를 제공
            let fileName = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(fileName).putData(uploadData, metadata: nil) { metaData, error in
                
                // 에러 처리
                if let error = error {
                    print("파이어 베이스 저장소에 이비지를 업로드 하는데 에러로 실패하였다. ", error.localizedDescription)
                }
                
                guard let profileImageURL = metaData?.path else { return }
                
                let dictionaryValues = ["name": fullName,
                                        "username": userName,
                                        "profileImageURL": profileImageURL]
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let values = [uid : dictionaryValues]
                
                // save User info to database
                Database.database().reference().child("users").updateChildValues(values) { error, ref in
                    print(" 유저가 성공적으로 만들어짐 ")
                }
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
            userNameTextField.hasText,
            imageSelected == true
        else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
}

// MARK: - Set Up Constraints
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

// MARK: - UIImagePicker
extension SignUpViewController: UIImagePickerControllerDelegate {
    @objc func handleSelectProfilePhoto() {
        // configure Image Picker
        let imagePicker = UIImagePickerController().then {
            $0.delegate = self
            $0.allowsEditing = true
        }
        
        // present image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // selected Image
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return }
        
        // set imageSelected to true
        imageSelected = true
        
        // configure plusPhotoBtn with selected image
                    //원처럼 보이기
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}