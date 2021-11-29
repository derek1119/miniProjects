//
//  BlogList.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/29.
//

import RxSwift
import RxCocoa
import UIKit
import Then

class BlogListView: UITableView, BindableView {
    let disposeBag = DisposeBag()
    
    let headerView = FilterView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 50)))
    
    // MainViewController -> BlogListView
    let cellData = PublishSubject<[BlogListCellData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tableview, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tableview.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as! BlogListCell
                cell.setDate(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        self.backgroundColor = .white
        self.register(BlogListCell.self, forCellReuseIdentifier: "BlogListCell")
        self.separatorStyle = .none
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
    
    func layout() {}
}
