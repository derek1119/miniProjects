//
//  ComposeViewController.swift
//  SHMemo
//
//  Created by Sh Hong on 2021/06/01.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editedMemo : Memo?
    var originalMemo : Memo?
    var dataIndex : Int?
    
    let editStyleButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed(_:)))
    let saveStyleButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(_:)))
    
    
    @IBOutlet var editOrSaveButton: UIBarButtonItem!
    
    @IBOutlet var titleTextView: UITextView! {
        didSet {
            if self.navigationItem.rightBarButtonItem == editStyleButton {
                titleTextView.isEditable = false
            }
            titleTextView.text = originalMemo?.title
        }
    }
    
    
    
    @IBOutlet var contentTextView: UITextView! {
        didSet {
            if self.navigationItem.rightBarButtonItem == editStyleButton {
                contentTextView.isEditable = false
            }
            contentTextView.text = originalMemo?.content
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        placeholderSetting()
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

extension ComposeViewController: UITextViewDelegate {
    
    // title textView placeholder
    func placeholderSetting() {
        if titleTextView.text.isEmpty {
            titleTextView.delegate = self
            titleTextView.text = "Title"
            titleTextView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text.isEmpty {
                titleTextView.text = "Title"
                titleTextView.textColor = UIColor.lightGray
            }
        }
    }
    
    @objc private func editButtonPressed(_ sender: Any) {
        contentTextView.isEditable = true
        titleTextView.isEditable = true
        self.navigationItem.rightBarButtonItem = saveStyleButton
        originalMemo?.content = contentTextView.text
        originalMemo?.title = titleTextView.text
    }
    
    @objc private func saveButtonPressed(_ sender: Any) {
        if originalMemo?.content == nil && originalMemo?.title == nil {
            guard let memo = contentTextView.text, memo.count > 0  else {
                alert(message: "메모를 입력하세요.")
                return
            }
            
            let newMemo = Memo(title: titleTextView.text ?? "", content: memo)
            Memo.dummyData.append(newMemo)
        } else {
            if originalMemo?.content != contentTextView.text || originalMemo?.title != titleTextView.text {
                editedMemo?.content = contentTextView.text
                editedMemo?.title = titleTextView.text
                alert2(message: "편집한 내용을 저장하시겠습니까?")
            }
        }
        
        contentTextView.isEditable = false
        titleTextView.isEditable = false
        
        self.navigationItem.rightBarButtonItem = editStyleButton
    }
    
    func alert2(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            
            if let index = self.dataIndex, let newMemo = self.editedMemo {
                Memo.dummyData.remove(at: index)
                Memo.dummyData.append(newMemo)
                print(Memo.dummyData)
            }
            
            self.navigationController!.popViewController(animated: true)
            
            
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            self.navigationController!.popViewController(animated: true)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
