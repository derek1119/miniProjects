//
//  GameModel.swift
//  RPSGame
//
//  Created by Sh Hong on 2021/08/26.
//

import UIKit

class GameModel {
        
    var myChoice : RPS?
    var comChoice : RPS?
    var result : Result?
    
    func rpsGame(comChoice y: RPS, myChoice x: RPS) -> Result {
        if x == y {
            return Result.same
        } else if x == .가위 && y == .보 {
            return Result.win
        } else if x == .바위 && y == .가위 {
            return Result.win
        } else if x == .보 && y == .바위 {
            return Result.win
        } else {
            return Result.lose
        }
    }
    
    func reset() {
        self.myChoice = nil
        self.comChoice = nil
        self.result = nil
    }
}
