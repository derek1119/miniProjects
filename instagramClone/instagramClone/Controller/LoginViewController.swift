//
//  LoginViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/12.
//

import UIKit
import Then
import SnapKit

class LoginViewController: UIViewController {
    
    let emailTextField = UITextField().then {
        $0.placeholder = "Email"
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 14)
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 14)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background color
        view.backgroundColor = .white
        
        setUpConstraints()
    }

}

extension LoginViewController {
    func setUpConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(view.safeArea.top).offset(40)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
    }
}
