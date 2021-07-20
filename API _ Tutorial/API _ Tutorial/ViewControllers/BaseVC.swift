//
//  BaseVC.swift
//  API _ Tutorial
//
//  Created by Sh Hong on 2021/07/20.
//

import UIKit

class BaseVC: UIViewController {
    var vcTitle : String = "" {
        didSet {
            print("UserListVC - vcTitle didSet() called : vcTitle : \(vcTitle)")
            self.title = vcTitle + "🧑‍💻"
        }
    }
    
    
}

