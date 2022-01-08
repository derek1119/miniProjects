//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/30.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    // FilterView 외부에서 관찰
    let sortButtonTapped = PublishRelay<Void>()
}
