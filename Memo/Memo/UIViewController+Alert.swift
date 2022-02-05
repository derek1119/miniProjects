//
//  UIViewController+Alert.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/21.
//

import UIKit
import SnapKit

extension UIViewController {
    //UIViewController 전반에 사용할 수 있도록 extension으로 구현
    func alert(title : String = "알림", message : String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // UIAlertController를 이용하여 alert 객체 만듬
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        //확인 객체 만듬 -> 확인 선택 후 어떤 이벤트도 일어나지 않으니 핸들러는 nil
        alert.addAction(okAction)
        //action을 만들었으면 alert에 추가해야함.
        
        present(alert, animated: true, completion: nil)
        //마지막 present를 이용해서 알림을 보여줘야함. 
    }
    //알림을 위한 함수 구현
}
