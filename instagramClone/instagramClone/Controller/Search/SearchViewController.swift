//
//  SearchViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit

private let reuseIdentifier = "SeachUserTableViewCell"

class SearchViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cell classes
        tableView.register(SeachUserTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // separator insets
                // 이미지의 너비(48) 만큼의 inset을 넣어줌 -> 64
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        configureNavController()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SeachUserTableViewCell
        
        return cell
    }

// MARK: - Handlers
    
    func configureNavController() {
        navigationItem.title = "Explore"
    }
}
