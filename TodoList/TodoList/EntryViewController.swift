//
//  EntryViewController.swift
//  TodoList
//
//  Created by Sh Hong on 2021/05/19.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    //delegate는 프로토콜로 구현이 된다. 프로토콜이란 일종의 약속, 규약이라고 생각하면 된다. 개발자는 프로토콜 내에 정의되어 있는 요소들, 즉 함수 프로토타입을 가지고 원하는 기능을 구현하면 된다.
    
    
    //task 입력을 위한 textfield outlet 연결
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        //여기서 위 의미는 텍스트 필드의 일은 내가 할게 하는 의미가 된다. 여기서 '내'는 현재 클래스인
        //EntryViewController이다. 즉, 텍스트 필드에 어떤 일(이벤트)가 일어나면 EntryViewController가 처리한다는 뜻이다.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        //navigationItem 중 rightbarButton에 save 버튼을 만들어서 done이라는 어떤 이벤트와 이전 화면으로 돌아가게 하는 스타일(.done)로 표현했다. target은 액션 메세지를 받는 객체인데 self라는 것은 (아마도?)버튼 자체에서 액션 메세지를 받는다는 의미인 것 같다. #selector란 함수를 직접 지정하는 기능을 가진 일종의 함수 선택자이다. 본래 object-c에서 클래스 메소드의 이름을 가르키는데 사용되는 참조타입이다.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }
    //텍스트 필드에 무슨 일이 발생하고 반환값이 있다라는 함수, 델리게이트를 '구현'하는 과정이다.
    //'사용자가 텍스트필드에 어떤 일을 하고 리턴될 것이다.'의 의미
    
    @objc func saveTask() {
        
        guard let text = field.text, !text.isEmpty else { return }
        //textfield의 텍스트가 있고 text가 뭔가 적혀져있다면 다음으로 넘어가 저장단계를 거치고 아니라면 return해라
        
        guard let count = UserDefaults.value(forKey: "count") as? Int else { return }
        //count는 데이터의 갯수(task)를 의미하며 이 값이 있다면 다음으로 가면서 타입캐스팅을 int로 하여라
        let newCount = count + 1
        UserDefaults().set(newCount, forKey: "count")
        //다음 데이터는 count + 1으로 새로운 키값 제공
        UserDefaults().set(text, forKey: "task_\(newCount)")
        //task의 고유번호에 대해 text를 저장(task 명이 될 것)
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }
    //#selector에서 사용되려면 @objc func이 되어야한다.
}
