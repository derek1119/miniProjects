//
//  SayHiModel.swift
//  SayHi
//
//  Created by Sh Hong on 2021/08/25.
//

import UIKit

enum SayHi {
    case sayHi
    case gradToMeetYou
}

func tapBtn (label : UILabel, state: inout SayHi) {
    switch state {
    case .sayHi:
        label.text = "반갑다!"
        state = .gradToMeetYou
    case .gradToMeetYou :
        label.text = "안녕하세요"
        state = .sayHi
    }
}
