//
//  ComposeViewController.swift
//  SHMemo
//
//  Created by Sh Hong on 2021/06/01.
//

import UIKit

class ComposeViewController: UIViewController {
    
//    var editedMemo = Memo()
    //https://developer.apple.com/documentation/coredata/modeling_data/generating_code
    var memo : Memo?
//    var dataIndex : Int?
    
    let editStyleButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed(_:)))
    let saveStyleButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(_:)))
    
    
    @IBOutlet var editOrSaveButton: UIBarButtonItem!
    
    @IBOutlet var titleTextView: UITextView! {
        didSet {
            if self.navigationItem.rightBarButtonItem == editStyleButton {
                titleTextView.isEditable = false
            }
            titleTextView.text = memo?.title
        }
    }
    
    
    
    @IBOutlet var contentTextView: UITextView! {
        didSet {
            if self.navigationItem.rightBarButtonItem == editStyleButton {
                contentTextView.isEditable = false
            }
            contentTextView.text = memo?.content
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        placeholderSetting()
        titleTextView.isScrollEnabled = false
        titleTextView.delegate = self
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = titleTextView.text ?? ""
        guard let strRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: strRange, with: text)
        
        return changedText.count <= 20
    }
    
    //edit & save button
    @objc private func editButtonPressed(_ sender: Any) {
        contentTextView.isEditable = true
        titleTextView.isEditable = true
        self.navigationItem.rightBarButtonItem = saveStyleButton
//        editedMemo.content = contentTextView.text
//        editedMemo.title = titleTextView.text
    }
    
    @objc private func saveButtonPressed(_ sender: Any) {
        if memo == nil {
            guard let memo = contentTextView.text, memo.count > 0 else {
                alert(message: "메모를 입력하세요.")
                return
            }
            
            DataManager.shared.addNewMemo(memo, titleTextView.text ?? "")
//            Memo.dummyData.append(newMemo)
            self.navigationController!.popViewController(animated: true)

        } else if memo?.content != contentTextView.text || memo?.title != titleTextView.text {
            guard let memo = contentTextView.text, memo.count > 0  else {
                alert(message: "메모를 입력하세요.")
                return
            }
            alert2(message: "편집한 내용을 저장하시겠습니까?")
        } else {
            self.navigationController!.popViewController(animated: true)
        }
        contentTextView.isEditable = false
        titleTextView.isEditable = false
        
        self.navigationItem.rightBarButtonItem = editStyleButton
    }
    
    func alert2(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            
//            guard let index = self.dataIndex else { return }
//            DataManager.shared.memoList.remove(at: index)
//            DataManager.shared.addNewMemo(self.editedMemo.content, self.editedMemo.title)
            self.memo?.content = self.contentTextView.text
            self.memo?.title = self.titleTextView.text ?? ""
            self.memo?.date = Date()
            DataManager.shared.saveContext()
            
            self.navigationController!.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            
//            self.editedMemo = Memo()
            self.navigationController!.popViewController(animated: true)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

