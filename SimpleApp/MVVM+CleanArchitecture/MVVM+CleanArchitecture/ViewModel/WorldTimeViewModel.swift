//
//  WorldTimeViewModel.swift
//  MVVM+CleanArchitecture
//
//  Created by Sh Hong on 2021/08/31.
//

import UIKit

class WorldTimeViewModel {
    
    var currentDateTime = Date()
    
    func fetchNow(label: UILabel) {
        let url = "http://worldclockapi.com/api/json/utc/now"
        currentDateTime = Date()
        label.text = "Loading..."
        
        URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] date, _, _ in
            guard let date = date else { return }
            guard let model = try? JSONDecoder().decode(TimeModel.self, from: date) else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            
            guard let now = formatter.date(from: model.currentDateTime) else { return }
            
            self?.currentDateTime = now
            
            DispatchQueue.main.async {
                self?.updateDateTime(label: label)
            }
        }.resume()
    }
    
    func updateDateTime(label: UILabel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        label.text = formatter.string(from: currentDateTime)
    }
}
