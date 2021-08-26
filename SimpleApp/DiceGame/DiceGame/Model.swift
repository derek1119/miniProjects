//
//  Model.swift
//  DiceGame
//
//  Created by Sh Hong on 2021/08/26.
//

import UIKit

class GameModel {
    enum DiceCollection : String, CaseIterable{
        case black1, black2, black3, black4, black5, black6
        
        static func random<G: RandomNumberGenerator>(using generator: inout G) -> DiceCollection {
            return DiceCollection.allCases.randomElement(using: &generator)!
        }
        
        static func random() -> DiceCollection {
            var g = SystemRandomNumberGenerator()
            return DiceCollection.random(using: &g)
        }
    }
    
    let imageDict : [UIImage] = [#imageLiteral(resourceName: "black1"), #imageLiteral(resourceName: "black2"), #imageLiteral(resourceName: "black3"), #imageLiteral(resourceName: "black4"), #imageLiteral(resourceName: "black5"), #imageLiteral(resourceName: "black6")]

    func randomImage2(image: UIImageView) {
        image.image = imageDict.randomElement()
    }
    
    func randomImage(image: UIImageView) {
        image.image = UIImage(named: DiceCollection.random().rawValue)
    }
}



   
