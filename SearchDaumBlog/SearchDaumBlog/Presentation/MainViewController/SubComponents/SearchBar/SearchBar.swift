//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/29.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    let searchButton = UIButton(type: .system)
    
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchBarViewModel) {
        Observable
            .merge(
                // 서치바의 서치 버튼(키보드 return)이 탭되는 경우
                self.rx.searchButtonClicked.asObservable(),
                // 버튼이 탭 되는 경우
                self.searchButton.rx.tap.asObservable()
            )
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        // 키보드를 내리기 위한
        viewModel.searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
       
    }
    
    func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    func layout() {
        addSubview(searchButton)
        
        searchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.right.equalTo(searchButton.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
        
       
    }
}

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
