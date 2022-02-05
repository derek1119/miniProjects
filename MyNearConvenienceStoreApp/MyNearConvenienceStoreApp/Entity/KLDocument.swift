//
//  KLDocument.swift
//  MyNearConvenienceStoreApp
//
//  Created by Sh Hong on 2022/02/05.
//

import Foundation

struct KLDocument: Decodable {
    let placeName: String
    let placeNameAddress: String
    let roadAddress: String
    let x: String
    let y: String
    let distance: String
    
    enum CodingKeys: String, CodingKey {
        case x, y, distance
        case placeName = "place_name"
        case placeNameAddress = "address_name"
        case roadAddress = "road_address_name"
    }
}
