//
//  BaseVC.swift
//  API _ Tutorial
//
//  Created by Sh Hong on 2021/07/20.
//

import UIKit
import Toast

class BaseVC: UIViewController {
    var vcTitle : String = "" {
        didSet {
            print("UserListVC - vcTitle didSet() called : vcTitle : \(vcTitle)")
            self.title = vcTitle + "ð§âð»"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ì¸ì¦ ì¤í¨ ë¸í°í¼ì¼ì´ì ë±ë¡
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notification:)), name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // ì¸ì¦ ì¤í¨ ë¸í°í¼ì¼ì´ì ë±ë¡ í´ì 
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil)
        
    }
    
    //MARK: - objc methods
    
    @objc func showErrorPopup(notification: NSNotification) {
        print("BaseVC - showErrorPopup()")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopup() data : \(data)")
           
            //ë©ì¸ì°ë ëìì ëë¦¬ê¸° ì¦ UIì°ë ë
            DispatchQueue.main.async {
                self.view.makeToast("â ï¸ \(data) ìë¬ ìëë¤.", duration: 1.5, position: .center)
            }

        }
    }
}

