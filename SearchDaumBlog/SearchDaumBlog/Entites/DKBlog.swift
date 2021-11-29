//
//  DKBlog.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/29.
//

import Foundation

struct DKBlog: Decodable {
    let documents: [DKDocument]
}

struct DKDocument: Decodable {
    let blogName: String?
    let datetime: Date?
    let thumbnailURL: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case blogName = "blogname"
        case datetime, title
        case thumbnailURL = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try? values.decode(String?.self, forKey: .title)
        self.blogName = try? values.decode(String?.self, forKey: .blogName)
        self.thumbnailURL = try? values.decode(String?.self, forKey: .thumbnailURL)
        self.datetime = Date.parse(values, key: .datetime)
    }
}

extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString: dateString) else {
                  return nil
              }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.locale = Locale(identifier: "ko-kr")
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return nil
    }
}
