//
//  ComposeViewController.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/21.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    
    @IBOutlet var memoTextView: UITextView!
    //memoTextView 아울렛으로 연결 -> 이를 컨트롤하기 위함.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //화면을 닫는 메소드
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요.")
            return
        }
        // memo.count > 0 인 이유는 텍스트가 입력되었는지 확인하는 것이고 만일 어떤 입력도 받지 않았다면 alert를 하고 return, 만일 텍스트가 입력되었다면 가드문 다음의 코드가 실행된다.
        
//        let newMemo = Memo(content: memo)
//        //memo를 Memo 모델의 컨텐트로 상수화 시키고
//        Memo.dummyMemoList.append(newMemo)
//        //이 텍스트를 dummyMemoList에 추가함.
        
        if let target = editTarget {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        //이 코드는 라디오 방송국에서 라디오 방송을 브로드케스팅(방송하는 것)과 같다. 노티피케이션은 특정 개체에게 바로 전달되지 않는다. 이를 유니케스트라고 부른다. 노티피케이션은 브로드 케스트이다. 앱을 구성하는 모든 개체로 전달된다. 이는 잘못된 설명이지만 처음 단계에서는 이렇게 이해해도 된다. 이제 여기서 전달한 노티피케이션을 처리해야한다. 옵저버를 등록하고 필요한 코드를 구현하는 방식으로 처리한다. 이는 마치 라디오 주파수를 맞추는 것에 비유할 수 있다.
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name("newMemoDidInsert")
    //full screen의 경우에는 viewWillAppear로 저장이 가능했으나 모달인 시트로 표시가 되면서 viewWillAppear가 호출되지 않아 노티피케이션으로 해결해보는 방법이다.
    //노티피케이션은 라디오방송이라고 생각하면 되며 라디오 방송국에 해당하는 노티피케이션 센터가 존재하고 라디오의 주파수는 이름으로 구분한다.
    //노티피케이션 이름 추가
    
    static let memoDidChange = Notification.Name("memoDidChange")
}
