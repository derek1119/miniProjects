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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, /*sender를 UITableViewCell로 타입캐스팅*/
           let indexPath = tableView.indexPath(for: cell) /* 바인딩된 셀을 테이블뷰로 전달해서 indexPath가져오기, 이를 통해 indexPath를 통해서 몇 번째 셀인지 확인할 수 있다. */ {
            if let vc = segue.destination as? DetailViewController {
                vc.memo = Memo.dummyMemoList[indexPath.row]
                //DetailViewController로 타입케스팅된 vc 내부에 memo 변수에 indexPath.row 값을 이용하여 배열의 몇 번째인지 찾아내어 저장한다. 
            }
        }
        //segue.source : 세그웨이를 실행하는 화면 / segue.destination : 새롭게 표시되는 화면
        //destination의 속성을 보면 그저 UIViewController이기 때문에 타입캐스팅을 해야한다.
    }
    //이 메소드는 세그웨이가 연결된 화면을 생성하고 화면을 전환하기 직전에 호출된다.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        tableView.reloadData()
//        //reloadDate()만 호출하면 데이터 소스가 전달해주는 최신 데이터로 업데이트한다.
//        print("View Will Appear")
    }
    // 뷰컨트롤러가 관리하는 뷰가 화면에 표시되기 직전에 자동으로 호출되는 메소드.
    
    var token : NSObjectProtocol?
    //토큰을 저장할 속성을 추가
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    //viewDidLoad에서 추가한 옵저버는 뷰가 화면에서 사라지기 전에 해제하거나 소멸자(deinit?)에서 해제한다. 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = NotificationCenter.default.addObserver(
            forName: ComposeViewController.newMemoDidInsert,
            //옵저버를 추가할 노티피케이션의 이름을 전달한다.
            object: nil,
            //특별한 이유가 없다면 nil
            queue: OperationQueue.main
            //노티피케이션이 전달되면 테이블 뷰를 업데이트해야한다. 다시 말해 UI를 update해야한다. UI update코드는 반드시 main thread에서 실행해야한다. 모든 프로그래밍에서 기본 중의 기본이다. iOS에서는 쓰레드를 직접 처리하지 않고 dispatchQueue나 operationQueue를 사용한다. 이렇게하면 옵저버가 실행하는 코드가 메인쓰레드에서 실행된다.
        ) { [weak self] (noti) in self?.tableView.reloadData()
            //마지막 파라미터에는 클로저를 실행한다. 노티피케이션이 전달되면 4번째 파라미터로 전달한 클로저가 3번째 파리미터로 전달한 쓰레드에서 실행된다.
        }
        //옵저버는 한번만 만들어놓으면 되기때문에 viewDidLoad에서 호출한다.
        //노티피케이션을 구현할 때 가장 중요한 것은 옵저버를 해제하는 것이다. 해제하지 않으면 내부적으로 메모리가 낭비된다. 위 코드에서 addObserver 메소드는 옵저버를 해제할 때 사용하는 객체를 리턴해준다. 보통 이 객체를 토큰이라고 부른다. 따라서 token을 만들고 addObserver가 리턴하는 토큰을 token에 저장하는 과정이다.

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //viewController가 생성된 후에 자동으로 호출된다. 주로 한번만 호출하는 초기화 코드를 여기서 호출한다.

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
