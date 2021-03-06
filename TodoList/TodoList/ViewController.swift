//
//  ViewController.swift
//  TodoList
//
//  Created by Sh Hong on 2021/05/19.
//

import UIKit

class ViewController: UIViewController {

    //Tableview outlet 설정, IBOutlet은 non-optional이다.
    @IBOutlet var tableView : UITableView!
    
    //업무에 대한 스트링 타입의 빈 배열 생성 -> 셀로 보냄
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
       
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        
        if UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        //UserDefaults란 간단히 얘기해서 "데이터 저장소"이다. UserDefaults를 이용하면 앱의 어느 곳에서나 데이터를 쉽게 읽고 저장할 수 있게된다. UserDefaults는 사용자 기본 설정과 단일 데이터 값에 적합하다. UserDefaults는 [데이터, 키(key)]으로 데이터를 저장한다. 이때 key의 값은 string이다. 이때 key값은 여러개의 데이터를 저장해야할 때를 위해 이 key값을 이용하므로 하고싶은 문자열로 저장하면 된다.
        // 만일 "setup"이 되어있지 않다면 setup 키에 해당하는 데이터를 true로 하고 "count"에 해당하는 값을 0으로하여라. 
        
        
        // 현재 저장된 모든 tasks를 불러오기.
        updateTasks()
        //view가 다 만들어지면 업데이트를 하여라
    }
    
    func updateTasks() {
        
        tasks.removeAll()
        //아래의 for문을 실행하게 되면 tasks에 중복으로 들어가기 때문에 먼저 비운다.

        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }
        
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                tasks.append(task)
            }
        }
        
        tableView.reloadData()
        //그리고 나서 다시 입력된 데이터를 불러온다. 
        
    }
    //task에 대한 데이터를 업데이트하는 함수
    //count라는 상수를 가지고 UserDefaults의 task 데이터를 훑어본 뒤에 빈 배열인 tasks에 추가한다.
    
    @IBAction func addButtonTapped() {
        
        
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        //위 코드는 스토리보드 파일로부터 데이터를 불러와서 viewController를 생성하고 메모리 공간의 allocation을 의미한다.
        //storyboard안에 기입한 storyboardID를 가지고 스토리보드 데이터를 초기화 해 viewController를 만든다.
        //instantiateViewController는 새로운 뷰로 넘어갈 때 사용해야 한다. 
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        //viewController를 초기화하면서 update변수에 updateTask함수를 넣음..? 클로저 ..? 함수의 변수화
        //add 버튼을 탭하는 이벤트가 발생하고 그냥 이해하자면 뷰컨트롤러의 updateTasks함수를 실행한다?

        //Queue란 영화 티켓을 살 때 줄 서는 것과 같다. 먼저 온 순서대로 먼저 나가는 것이다. FIFO(first in first out)자료구조
        //DispatchQueue는 작업항목의 실행을 관리하는 클래스이다. 대기열(Queue)에 추가된 작업항목은 시스템이 관리하는 스레드풀에서 처리하고 작업을 완료하면 알아서 해제한다.
        //.main은 현 프로세스의 main thread와 관련된 dispatch queue이다. 
        //async와 sync는 비동기와 동기의 차이이다. synchronous 함수는 작업이 다 끝난 다음에만 현재의 queue에게 컨트롤을 넘기며 그 전까지 현재의 queue는 block되어 작업이 끝날 때까지 기다려야한다. asynchronous 함수는 작업을 수행할 다른 큐에게 작업을 넘기자마자 현재의 queue에게 컨트롤을 돌려준다. 작업이 끝나기 전까지 기다릴 필요가 없으며 현재의 queue도 block되지 않는다.
        navigationController?.pushViewController(vc, animated: true)
        // 위 방식은 네비게이션컨트롤러를 사용하여 화면 전환하는 방법이다.
    }


}
//셀과 상호작용하는 tableview의 델리게이트
extension ViewController : UITableViewDelegate {
    
    //셀이 선택된 직후 작동하는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //셀이 선택되면 애니메이션 작동
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "New Task"
        vc.task = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        //cell 선택시 taskViewController로 이동
    }
}

//셀에 표현될 데이터 소스를 상호작용하는 extention, 즉 테이블뷰와 관련된 데이터를 제공하기 위함
extension ViewController : UITableViewDataSource {
    
    //tableViewDataSource에서 무조건 가지고 있어야하는 것 -> 섹션 안에 있는 row(행)의 갯수를 리턴해주는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //셀을 만들어낼 때는 아래 코드가 한번만 불리게 되면서 모든 셀이 다 만들어지는 것이 아니라 이 함수는 cell하나를 리턴하기 때문에 cell이
    //만들어질때마다 아래 함수가 호출이 된다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //dequeueReusableCell이란 지정된 재사용 식별자에 대한 재사용 가능한 테이블 뷰 셀 객체를 반환하고 이를 테이블에 추가
        //지정된 (재사용) 식별자란 withIdentifier가 될 것이며 string형 identifier는 재사용할 객차를 나타낸다.
        //여기서 for란 indexPath인데 셀의 위치를 알려주는 것
        //데이터 소스는 셀에 대한 요청이 있을 때 이 정보를 수신하며 이를 전달해야한다. 이 방법은 인덱스 경로를 사용하여 테이블뷰에서 셀의 위치를 기반으로 추가 구성을 수행한다.
        
        cell.textLabel?.text = tasks[indexPath.row]
        //indexPath란 행을 식별하는 인덱스 경로이다. indexPath는 [?, row]의 값을 갖는다.
        //앞의 ?는 셀의 섹션을 의미하고 row는 해당 섹션의 row번째 행을 말한다.
        
        return cell
    }
    
    
}
