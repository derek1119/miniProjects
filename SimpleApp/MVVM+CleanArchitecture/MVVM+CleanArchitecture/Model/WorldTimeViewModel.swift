//
//  WorldTimeViewModel.swift
//  MVVM+CleanArchitecture
//
//  Created by Sh Hong on 2021/08/31.
//

import UIKit

class WorldTimeViewModel {
    
    var onUpdate: () -> Void = {}
    
    var dateTimeString: String = "Loading..." {
        didSet {
            onUpdate()
        }
    }
    
    let service = Service()
    
   
    
    func moveDay(day: Int) {
        service.moveDay(day: day)
        dateTimeString = dateToString(date: service.currentModel.currentDateTime)
    }
    
    func reload() {
        service.fetchNow { [weak self] model in
            guard let self = self else { return }
            let dateString = self.dateToString(date: model.currentDateTime)
            self.dateTimeString = dateString
        }
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return formatter.string(from: date)
    }
}
