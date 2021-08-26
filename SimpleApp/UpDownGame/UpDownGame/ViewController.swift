//
//  ViewController.swift
//  UpDownGame
//
//  Created by Sh Hong on 2021/08/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var targetNum = Int.random(in: 1...10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = "선택하세요"
        inputLabel.text = ""
    }
    
    @IBAction func numBtns(_ sender: UIButton) {
        let currentNumStr = sender.currentTitle!
        inputLabel.text = currentNumStr
    }
    
    @IBAction func selectBtnTapped(_ sender: Any) {
        guard let myNumStr = inputLabel.text, let myNum = Int(myNumStr) else { resultLabel.text = "숫자를 입력하세요"
            return }
        
        self.backView.backgroundColor = .gray
        if targetNum > myNum {
            resultLabel.text = "UP!"
            reactionBackView(color: .red)
        } else if targetNum < myNum {
            resultLabel.text = "DOWN"
            reactionBackView(color: .blue)
        } else {
            resultLabel.text = "BINGO"
            reactionBackView(color: .yellow)
        }
        
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        resultLabel.text = "선택하세요"
        backView.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        inputLabel.text = ""
        targetNum = Int.random(in: 1...10)
    }
    
    func reactionBackView(color: UIColor) {
        UIView.animate(withDuration: 0.5) {
            self.backView.backgroundColor = color
        }

    }
}

