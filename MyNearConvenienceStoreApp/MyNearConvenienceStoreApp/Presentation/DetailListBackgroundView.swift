//
//  DetailListBackgroundView.swift
//  MyNearConvenienceStoreApp
//
//  Created by Sh Hong on 2022/02/05.
//

import RxSwift
import RxCocoa

class DetailListBackgroundView: UIView {
    let disposeBag = DisposeBag()
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    func bind(_ viewModel: DetailListBackgroundViewModel) {
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        backgroundColor = .white
        
        statusLabel.text = "🏪"
        statusLabel.textAlignment = .center
    }
    
    private func layout() {
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

