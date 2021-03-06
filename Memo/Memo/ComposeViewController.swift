//
//  ComposeViewController.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/21.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    var originalMemoContent: String?
    //편집 이전의 메모 내용 저장
    
    @IBOutlet var memoTextView: UITextView!
    //memoTextView 아울렛으로 연결 -> 이를 컨트롤하기 위함.
    
    //토큰을 저장할 속성 생성
    var willShowToken : NSObjectProtocol?
    var willHideToken : NSObjectProtocol?
    //위의 속성들은 옵저버를 해제할 때 사용된다.
    
    deinit {
    //소멸자
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    //위 코드로 인해 화면이 해제되는 시점에 옵저버도 해제된다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
        
        //옵저버 등록 코드
        //키보드가 표시되기 전에 전달되는 노티피케이션
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            //키보드 높이만큼 여백 추가
            guard let strongSelf = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                var inset = strongSelf.memoTextView.contentInset
                
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                //텍스트뷰 오른쪽 스크롤바에도 여백을 추가해야 한다.
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
                
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.becomeFirstResponder()
        //입력 포커스가 되며 자동으로 키보드가 올라옴 
        navigationController?.presentationController?.delegate = self
        //편집화면이 표시되기 직전에 델리게이트로 설정됨
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        memoTextView.resignFirstResponder()
        //입력 포커스가 사라지고 키보드가 내려감
        navigationController?.presentationController?.delegate = nil
        //편집화면이 사라지기 직전에 델리게이트 해제
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

extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            isModalInPresentation = original != edited
            //original 메모와 편집된 메모가 다를 때 isModalInPresentation 속성에 true를 저장
            //원본과 편집본의 내용이 다르다면 모달 프리젠테이션 꺼낼 것
        }
    }
    //텍스트를 편집할 때마다 반복적으로 호출됨
}

extension ComposeViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.saveButtonTapped(action)
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.cancelButtonTapped(action)
        }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name("newMemoDidInsert")
    //full screen의 경우에는 viewWillAppear로 저장이 가능했으나 모달인 시트로 표시가 되면서 viewWillAppear가 호출되지 않아 노티피케이션으로 해결해보는 방법이다.
    //노티피케이션은 라디오방송이라고 생각하면 되며 라디오 방송국에 해당하는 노티피케이션 센터가 존재하고 라디오의 주파수는 이름으로 구분한다.
    //노티피케이션 이름 추가
    
    static let memoDidChange = Notification.Name("memoDidChange")
}

