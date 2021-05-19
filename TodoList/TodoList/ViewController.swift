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
        // 현재 저장된 모든 tasks를 불러오기.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addButtonTapped() {
        
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        //위 코드는 스토리보드 파일로부터 데이터를 불러와서 viewController를 생성하고 메모리 공간의 allocation을 의미한다.
        //storyboard안에 기입한 storyboardID를 가지고 스토리보드 데이터를 초기화 해 viewController를 만든다.
        //instantiateViewController는 새로운 뷰로 넘어갈 때 사용해야 한다. 
        vc.title = "New Task"
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
