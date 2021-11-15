//
//  CustomImageView.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/22.
//

import UIKit

var imageCach = [String: UIImage]()

class CustomImageView: UIImageView {
    // 캐쉬를 이용하여 매번 api에서 불러오는 것이 아닌 한번만 불러와서 저장소에 저장하는 기능 구현
    
    var lastImgUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        // 이미지를 nil로 설정 -> 복사된 것 처럼 보이지 않기 위해
        self.image = nil
        
        // set lastImgUrlUsedToLoadImage -> 체크하기 위한 설정
        lastImgUrlUsedToLoadImage = urlString
        
        // 캐시 안에 이미지가 존재하는지 확인
        if let cachedImage = imageCach[urlString] {
            self.image = cachedImage
            return
        }
        
        // 이미지가 캐시 안에 존재하지 않는 경우
        
        // 이미지가 존재하는 url
        guard let url = URL(string: urlString) else { return }
        
        // fetch contents of URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("이미지 호출 실패: ", error.localizedDescription)
            }
            
            if self.lastImgUrlUsedToLoadImage != url.absoluteString {
                return
            }
            
            // image data
            guard let imageData = data else { return }
            
            // 이미지 데이터를 이용해서 이미지 저장하기
            let photoImage = UIImage(data: imageData)
            
            // set key and value for image cache
            imageCach[url.absoluteString] = photoImage
            
            // set image
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
        }.resume()
    }
}
