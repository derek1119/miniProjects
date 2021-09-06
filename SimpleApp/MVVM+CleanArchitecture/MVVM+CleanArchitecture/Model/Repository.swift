//
//  Repository.swift
//  MVVM+CleanArchitecture
//
//  Created by Sh Hong on 2021/09/01.
//

import Foundation

class Repository {
    func fetchNow(onCompleted: @escaping (Entity) -> Void) {
        let url = "http://worldclockapi.com/api/json/utc/now"
        
        URLSession.shared.dataTask(with: URL(string: url)!) {  date, _, _ in
            guard let date = date else { return }
            guard let model = try? JSONDecoder().decode(Entity.self, from: date) else { return }
            
            onCompleted(model)
        }.resume()
    }
}
