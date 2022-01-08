//
//  FilterView.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/29.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

class FilterView: UITableViewHeaderFooterView {
    
    
    let disposeBag = DisposeBag()
    
    let sortButton = UIButton(type: .system)
    let bottomBorder = UIView()
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: FilterViewModel) {
        sortButton.rx.tap
            .bind(to: viewModel.sortButtonTapped)
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        bottomBorder.backgroundColor = .lightGray
    }
    
    func layout() {
        [sortButton, bottomBorder]
            .forEach{ addSubview($0) }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(28)
            make.centerY.equalToSuperview()
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}
