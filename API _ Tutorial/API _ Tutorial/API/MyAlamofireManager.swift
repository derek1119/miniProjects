//
//  MyAlamofireManager.swift
//  API _ Tutorial
//
//  Created by Sh Hong on 2021/07/23.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamofireManager {
    
    // 싱글턴 적용
    static let shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors :
        [
            BaseInterceptor()
            
        ])
    
    //로거 설정
    let monitors = [MyLogger(), MyApiStatusLogger()] as [EventMonitor]
    
    // 세션 설정
    var session : Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors )
    }
    
    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], MyError>) -> Void) {
        
        print("MyAlamofireManager - getPhotos() called : \(userInput)")
        
        self.session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                
                var photos = [Photo]()
                let responseJson = JSON(responseValue)
                
                let jsonArr = responseJson["results"]
                
                print("jsonArr.count : \(jsonArr.count)")
                
                for (index, subJson): (String, JSON) in jsonArr {
                    print("index : \(index), subJson : \(subJson)")
                    
                    // 데이터 파싱
                    
                    let thumnail = subJson["urls"]["thumb"].string ?? ""
                    let username = subJson["user"]["username"].string ?? ""
                    let likesCount = subJson["likes"].intValue
                    let createdAt = subJson["created_at"].string ?? ""
                    
                    let photoItem = Photo(thumbnail: thumnail, username: username, likesCount: likesCount, createdAt: createdAt)
                    
                    // 배열에 넣고
                    photos.append(photoItem)

                    if photos.count > 0 {
                        completion(.success(photos))
                    } else {
                        completion(.failure(MyError.noContent))
                    }
                }
            })
    }
}
