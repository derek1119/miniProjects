//
//  Model.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/20.
//

import Foundation

class Memo {
    var content : String
    //메모 내용 저장
    var insertDate : Date
    //메모를 추가한 날짜
    
    init(content : String) {
        self.content = content
        insertDate = Date()
        //insertDate는 현재의 시간을 바로 저장하면 되기 때문에 별도의 파라미터로 받을 필요가 없다.
    }
    //class이기 때문에 초기화를 해야한다.
    
    static var dummyMemoList = [
        Memo(content: "Lorem Ipsum"),
        Memo(content: "구독 좋아요 이거 잘돼라")
    ]
    //더미데이터 만들기
    
}
