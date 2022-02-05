//
//  UIViewController + Alert.swift
//  SHMemo
//
//  Created by Sh Hong on 2021/06/04.
//

import UIKit
import SnapKit

extension UIViewController {
    func alert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
                
        present(alert, animated: true, completion: nil)
    }
}

