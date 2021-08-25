//
//  ViewController.swift
//  SayHi
//
//  Created by Sh Hong on 2021/08/25.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var state : SayHi = .sayHi
    
    @IBOutlet weak var talkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sayHiBtn(_ sender: UIButton) {
      tapBtn(label: talkLabel, state: &state)
    }
    
}

