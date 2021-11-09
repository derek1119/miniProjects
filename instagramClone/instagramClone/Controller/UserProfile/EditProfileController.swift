//
//  EditProfileController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/09.
//

import UIKit

class EditProfileController: UIViewController {
    
    // MARK: - Properties
    
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
    }
    
    // MARK: - Handler
    
    @objc func handleChangeProfilePhoto() {
        print(#function)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        print(#function)
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
            make.width.bottom.left.equalTo(fullNameTextField)
            make.height.equalTo(0.5)
        }
        
        view.addSubview(userNameSeparatorView)
        userNameSeparatorView.snp.makeConstraints { make in
            make.width.bottom.left.equalTo(userNameTextField)
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
}
