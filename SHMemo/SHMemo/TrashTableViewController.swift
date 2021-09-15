//
//  TrashTableViewController.swift
//  SHMemo
//
//  Created by Sh Hong on 2021/06/28.
//

import UIKit

class TrashTableViewController: UITableViewController {
    
    var trashedMemo : [Memo]?
    var arrStatusBool = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let count = trashedMemo?.count else { return }
//        for i in count {
//        arrStatusBool.append(false)
//        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.trashedMemoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trashedMemoCell", for: indexPath)
        if let target = trashedMemo {
        cell.textLabel?.text = target[indexPath.row].title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if arrStatusBool[indexPath.row] {
            arrStatusBool[indexPath.row] = false
        } else {
            arrStatusBool[indexPath.row] = true
        }
        
        if arrStatusBool[indexPath.row] {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }

}
