//
//  WorldTimeViewController.swift
//  MVVM+CleanArchitecture
//
//  Created by Sh Hong on 2021/08/31.
//

import UIKit

class WorldTimeViewController: UIViewController {

    let viewModel = WorldTimeViewModel()
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.timeLabel.text = self?.viewModel.dateTimeString
            }
        }
        
        viewModel.reload()
        timeLabel.text = viewModel.dateTimeString
    }
    
    @IBAction func onYesterday(_ sender: UIButton) {
        viewModel.moveDay(day: -1)
    }
    
    @IBAction func onToday(_ sender: UIButton) {
        
        viewModel.reload() 
    }
    
    @IBAction func onTomorrow(_ sender: UIButton) {
        viewModel.moveDay(day: 1)
    }
    
    
}
