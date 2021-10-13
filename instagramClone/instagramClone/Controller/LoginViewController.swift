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
    
    let loginButton = UIButton(type: .system).then {
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        $0.layer.cornerRadius = 5
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
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeArea.leading).offset(40)
            make.trailing.equalTo(view.safeArea.trailing).offset(-40)
            make.top.equalTo(view.safeArea.top).offset(40)
            make.height.equalTo(140)
        }
    }
}
