//
//  ViewController.swift
//  RPSGame
//
//  Created by Sh Hong on 2021/08/26.
//

import UIKit

class ViewController: UIViewController {

    let gameModel = GameModel()
    var myChoice : RPS?
    var comChoice : RPS?
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var comImageView: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var comChoiceLabel: UILabel!
    @IBOutlet weak var myChoiceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ready()
    }
    
    @IBAction func rpsBtnTapped(_ sender: UIButton) {
        
        guard let my = RPS(rawValue: sender.currentTitle ?? "바위") else { return }
        updateUI(label: myChoiceLabel, imageView: myImageView, rps: my)
        
    }
    
    @IBAction func selectBtnTapped(_ sender: UIButton) {
        comChoice = RPS.random()
        
        guard let comChoice = comChoice, let myChoice = myChoice else { return }
        updateUI(label: comChoiceLabel, imageView: comImageView, rps: comChoice)

        let result = gameModel.rpsGame(comChoice: comChoice, myChoice: myChoice)
        mainLabel.text = result.rawValue
    }
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        ready()
    }
    
    
    
    func ready() {
        comImageView.image = #imageLiteral(resourceName: "ready")
        myImageView.image = #imageLiteral(resourceName: "ready")
        mainLabel.text = "CHOOSE!"
        comChoiceLabel.text = "준비"
        myChoiceLabel.text = "준비"
        
        myChoice = nil
        comChoice = nil
    }
    
    func updateUI(label: UILabel, imageView: UIImageView, rps: RPS) {
        imageView.image = UIImage(named: rps.rawValue)
        label.text = rps.rawValue
    }
}

