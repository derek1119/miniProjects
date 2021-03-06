//
//  LoginViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/12.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let logoContainerView = UIView().then { container in
        container.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white")!)
        logoImageView.contentMode = .scaleAspectFill
        container.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }
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
    
    let loginButton = UIButton(type: .system).then {
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .isUnableStateColor
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    let dontHaveAccountButton = UIButton(type: .system).then {
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.isEnableStateColor]))
        
        $0.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background color
        view.backgroundColor = .white
        
        //hide nav bar
        navigationController?.navigationBar.isHidden = true
        
        setUpConstraints()
    }

    @objc func handleShowSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func formValidation() {
        guard emailTextField.hasText,
              passwordTextField.hasText else {
                  loginButton.isEnabled = false
                  loginButton.backgroundColor = .isUnableStateColor
                  return }
        // handle case for conditions were met
        loginButton.isEnabled = true
        loginButton.backgroundColor = .isEnableStateColor
    }
    
    @objc func handleLogin() {
        print(#function)
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            // handle sign in error
            if let error = error {
                print("???????????? ????????? ?????? ??????: ", error.localizedDescription)
                return
            }
            
            // handle success
            print("??????????????? ?????????")
            if #available(iOS 15, *) {
                guard let mainTabVC = UIApplication.KeyWindow?.rootViewController as? MainTabViewController
                else { return }
                // configure view controllers in maintabVC
                mainTabVC.configureViewControllers()
            } else if #available(iOS 13, *) {
                guard let mainTabVC = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController as? MainTabViewController
                else {
                    return }
                // configure view controllers in maintabVC

                mainTabVC.configureViewControllers()
            } else {
                guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabViewController
                else { return }
                // configure view controllers in maintabVC

                mainTabVC.configureViewControllers()
            }
            // dismiss login controller
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

extension LoginViewController {
    private func setUpConstraints() {
        
        view.addSubview(logoContainerView)
        
        logoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.safeArea.leading)
            make.trailing.equalTo(view.safeArea.trailing)
            make.height.equalTo(150)
        }
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeArea.leading).offset(40)
            make.trailing.equalTo(view.safeArea.trailing).offset(-40)
            make.top.equalTo(logoContainerView.snp.bottom).offset(40)
            make.height.equalTo(140)
        }
        
        view.addSubview(dontHaveAccountButton)
        
        dontHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
       
    }
}
