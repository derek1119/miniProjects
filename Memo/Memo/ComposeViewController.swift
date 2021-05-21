//
//  ComposeViewController.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/21.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet var memoTextView: UITextView!
    //memoTextView 아울렛으로 연결 -> 이를 컨트롤하기 위함.
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let newMemo = Memo(content: memo)
        //memo를 Memo 모델의 컨텐트로 상수화 시키고
        Memo.dummyMemoList.append(newMemo)
        //이 텍스트를 dummyMemoList에 추가함.
        
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
