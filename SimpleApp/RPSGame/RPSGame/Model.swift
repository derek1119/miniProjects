//
//  Model.swift
//  RPSGame
//
//  Created by Sh Hong on 2021/08/26.
//

import Foundation

enum RPS: String, CaseIterable{
    
    case 가위, 바위, 보
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> RPS {
        return RPS.allCases.randomElement(using: &generator)!
    }
    
    static func random() -> RPS {
        var g = SystemRandomNumberGenerator()
        return RPS.random(using: &g)
    }
}

enum Result: String {
    case win = "이겼다", lose = "졌다", same = "비겼다"
}
