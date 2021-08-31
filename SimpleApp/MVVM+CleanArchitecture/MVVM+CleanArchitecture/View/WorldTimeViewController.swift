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
        
        viewModel.fetchNow(label: timeLabel)
    }
    
    @IBAction func onYesterday(_ sender: UIButton) {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.currentDateTime) else {
            return
        }
        viewModel.currentDateTime = yesterday
        viewModel.updateDateTime(label: timeLabel)
    }
    
    @IBAction func onToday(_ sender: UIButton) {
        viewModel.fetchNow(label: timeLabel)
    }
    
    @IBAction func onTomorrow(_ sender: UIButton) {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: +1, to: viewModel.currentDateTime) else {
            return
        }
        viewModel.currentDateTime = yesterday
        viewModel.updateDateTime(label: timeLabel)
    }
    
    
}
