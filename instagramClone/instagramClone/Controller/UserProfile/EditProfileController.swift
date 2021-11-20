//
//  EditProfileController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/09.
//

import UIKit
import Firebase

class EditProfileController: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    var imageChanged = false
    var userNameChanged = false
    var userProfileVC: UserProfileViewController?
    var updatedUserName: String?
    
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let changePhotoButton = UIButton(type: .system).then { button in
        button.setTitle("프로필 사진 바꾸기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let userNameTextField = UITextField().then {
        $0.textAlignment = .left
        $0.borderStyle = .none
    }
    
    let fullNameTextField = UITextField().then {
        $0.textAlignment = .left
        $0.borderStyle = .none
        $0.isUserInteractionEnabled = false
    }
    
    let userNameLabel = UILabel().then {
        $0.text = "User Name"
        $0.font = .systemFont(ofSize: 16)
    }
    
    let fullNameLabel = UILabel().then {
        $0.text = "Full Name"
        $0.font = .systemFont(ofSize: 16)
    }
    
    let userNameSeparatorView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let fullNameSeparatorView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //configure navigationbar items
        configureNavigationBar()
        
        // configure view components
        configureViewComponents()
        
        userNameTextField.delegate = self
        
        // load user data
        loadUserData()
    }
    
    // MARK: - Handler
    
    @objc func handleChangeProfilePhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        
        view.endEditing(true)
        
        if userNameChanged {
            updateUserName()
        }
        
        if imageChanged {
            updateProfileImage()
        }
    }
    
    func loadUserData() {
        guard let user = user else { return }
        
        profileImageView.loadImage(with: user.profileImageURL!)
        fullNameTextField.text = user.name
        userNameTextField.text = user.username

    }
    
    func configureViewComponents() {
        
        view.backgroundColor = .white
        
        let containerView = UIView().then {
            $0.backgroundColor = .systemGroupedBackground
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(view.safeArea.top)
        }
        
        containerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
            profileImageView.layer.cornerRadius = 80 / 2
        }
        
        containerView.addSubview(changePhotoButton)
        changePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalTo(profileImageView)
        }
        
        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        view.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(20)
            make.left.equalTo(view.safeArea.left).offset(12)
        }
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(20)
            make.left.equalTo(view.safeArea.left).offset(12)
        }
        
        view.addSubview(fullNameTextField)
        fullNameTextField.snp.makeConstraints { make in
            make.left.equalTo(fullNameLabel.snp.right).offset(16)
            make.top.equalTo(fullNameLabel)
            make.width.equalToSuperview().dividedBy(1.6)
        }
        
        view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { make in
            make.left.equalTo(fullNameTextField.snp.left)
            make.top.equalTo(userNameLabel)
            make.width.equalToSuperview().dividedBy(1.6)
        }
        
        view.addSubview(fullNameSeparatorView)
        fullNameSeparatorView.snp.makeConstraints { make in
            make.bottom.equalTo(fullNameLabel).offset(8)
            make.width.left.equalTo(fullNameTextField)
            make.height.equalTo(0.5)
        }
        
        view.addSubview(userNameSeparatorView)
        userNameSeparatorView.snp.makeConstraints { make in
            make.bottom.equalTo(userNameTextField).offset(8)
            make.width.left.equalTo(userNameTextField)
            make.height.equalTo(0.5)
        }
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.title = "프로필 수정"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(handleDone))
    }
    
    // MARK: - API
    
    func updateUserName() {
        guard let updatedUserName = updatedUserName else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard userNameChanged == true else { return }
        
        USER_REF.child(currentUid).child("username").setValue(updatedUserName) { err, ref in
            guard let userProfileVC = self.userProfileVC else { return }
            userProfileVC.fetchCurrentUserData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateProfileImage() {
        
        guard imageChanged == true else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = user else { return }
        
        Storage.storage().reference(forURL: user.profileImageURL!).delete(completion: nil)
        
        let filename = NSUUID().uuidString
        
        guard let updatedProfileImage = profileImageView.image else { return }
        guard let imageData = updatedProfileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let storageRef = STORAGE_PROFILE_IMAGES_REF.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to upload image to storage with error: ", err.localizedDescription)
            }
            
            storageRef.downloadURL { downloadUrl, error in
                guard let updatedProfileImageUrl = downloadUrl?.absoluteString else { return }
                
                USER_REF.child(currentUid).child("profileImageURL").setValue(updatedProfileImageUrl) { err, ref in
                    guard let userProfileVC = self.userProfileVC else { return }
                    userProfileVC.fetchCurrentUserData()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }

        
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            self.imageChanged = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let user = user else { return }
        
        let trimmedString = userNameTextField.text?.replacingOccurrences(of: "\\s+S", with: "", options: .regularExpression)
        
        guard user.username != trimmedString else {
            print("사용자 이름을 변경하지 않았습니다. ")
            userNameChanged = false
            return
        }
        
        guard trimmedString != "" else {
            print("Error : 이름을 입력해주세요.")
            return
        }
        
        updatedUserName = trimmedString
        userNameChanged = true
    }
}
