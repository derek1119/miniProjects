//
//  SearchBarViewModel.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/30.
//

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    
    let queryText = PublishRelay<String?>()
    // SearchBar 버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    
    // searchbar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")

    
    init() {
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
    }
 
}
