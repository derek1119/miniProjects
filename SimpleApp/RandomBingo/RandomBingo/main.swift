//
//  main.swift
//  RandomBingo
//
//  Created by Sh Hong on 2021/08/26.
//

import Foundation

var targetNum = Int.random(in: 1...100)

var myChoice = 0

while true {
    let userInput = readLine()
    
    if let input = userInput, let number = Int(input) {
        myChoice = number
    }
    
    if targetNum > myChoice {
        print("Up")
    } else if targetNum < myChoice {
        print("Down")
    } else {
        print("Bingo")
        break
    }
    
}
