//
//  ViewController.swift
//  DiceGame
//
//  Created by Sh Hong on 2021/08/25.
//

import UIKit

class ViewController: UIViewController {
    
    let gameModel = GameModel()
    
    @IBOutlet weak var leftDice: UIImageView!
    @IBOutlet weak var rightDice: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func rollBtnTapped(_ sender: UIButton) {
        gameModel.randomImage(image: leftDice)
        gameModel.randomImage2(image: rightDice)
    }
    
}

