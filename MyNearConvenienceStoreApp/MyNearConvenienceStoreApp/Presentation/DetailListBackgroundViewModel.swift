//
//  DetailListBackgroundViewModel.swift
//  MyNearConvenienceStoreApp
//
//  Created by Sh Hong on 2022/02/05.
//

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel {
    // viewModel -> view
    let isStatusLabelHidden: Signal<Bool>
    
    // 외부에서 전달받은 값
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: false)
    }
}
