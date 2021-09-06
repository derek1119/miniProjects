//
//  Logic.swift
//  MVVM+CleanArchitecture
//
//  Created by Sh Hong on 2021/09/01.
//

import Foundation

class Service {
    
    let repository = Repository()
    
    var currentModel = Model(currentDateTime: Date())
    
    func moveDay(day: Int){
        guard let movedDay = Calendar.current.date(byAdding: .day, value: day, to: currentModel.currentDateTime) else {
            return
        }
        currentModel.currentDateTime = movedDay
    }
    
    
    func fetchNow(onCompleted: @escaping (Model) -> Void ) {
        repository.fetchNow { entity in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            
            guard let now = formatter.date(from: entity.currentDateTime) else { return }
                        
            let model = Model(currentDateTime: now)
            
            onCompleted(model)
        }
    }
}
