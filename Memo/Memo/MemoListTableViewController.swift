//
//  MemoListTableViewController.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/20.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        //날짜 표시 형식을 한국 형식으로 바꿔줌 
        
        return f
    }()
    //DateFormatter로 날짜 표시 형식을 long, 시간 형식을 short으로 설정, fomatter라는 새로운 속성은 클로저를 활용해 초기화를 했음.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    //table view는 바보이기 때문에 몇 개의 셀이 필요하고 각 셀을 어떤 디자인으로 해야할지 모른다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Memo.dummyMemoList.count
        //Model의 Memo 클래스의 dummyMemoList의 갯수만큼 행을 생성
    }
    //먼저 위 메소드를 호출하여 몇 개의 셀을 생성해야하는지 답변을 받는다.

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //indexPath는 목록 내에서 특정 셀 위치를 표현할 때 사용한다.
        
        // Configure the cell...
        let target = Memo.dummyMemoList[indexPath.row]
        //해당 행과 일치하는 배열의 값을 target 상수로 만듬
        cell.textLabel?.text = target.content
        //cell의 textLabel에 content 데이터를 입력함
        cell.detailTextLabel?.text = formatter.string(from: target.insertDate)
        //formatter에서 string(from: )메소드를 호출하고 날짜를 전달하면 위에서 지정한 스타일로 포맷팅해서 문자열로 리턴해준다.
        

        return cell
    }
    //그리고 위 메소드를 호출하여 각 셀의 어떤 정보를 어떤 디자인으로 할지 답변을 받는다. 이때 indexPath파라미터로 몇 번째 셀인지 확인하며 셀을 생성할 때 마다 위 메소드를 반복적으로 호출된다.

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
