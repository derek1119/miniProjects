//
//  ComposeViewController.swift
//  SHMemo
//
//  Created by Sh Hong on 2021/06/01.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    var memo : Memo?
    
    @IBOutlet var editOrSaveButton: UIBarButtonItem!
    
    @IBOutlet var titleTextView: UITextView! {
        didSet {
            titleTextView.text = memo?.title
        }
    }
    
    @IBOutlet var contentTextView: UITextView! {
        didSet {
            contentTextView.text = memo?.content
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        placeholderSetting()
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
