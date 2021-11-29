//
//  MainViewController.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/29.
//

import RxSwift
import RxCocoa
import UIKit

class MainViewController: UIViewController, BindableView {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let listView = BlogListView()
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        
    }
    
    func attribute() {
        navigationItem.title = "다음 블로그 검색"
        view.backgroundColor = .white
    }
    
    func layout() {
        [searchBar, listView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
        }
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
}

// Alert
extension MainViewController{
    
}
