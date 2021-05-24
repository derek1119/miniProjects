//
//  DetailViewController.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var memo : Memo?
    //viewController가 초기화되는 시점에는 값이 없기 때문에 옵셔널로 선언해줌
    //이전 화면에서 전달한 메모가 저장된다. 
    
    let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        //날짜 표시 형식을 한국 형식으로 바꿔줌
        
        return f
    }()
    //dateCell에 날짜 정보를 넣기 위한 날짜 formatter 복사 붙여넣기
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            
            return cell
        default :
            fatalError()
            //Unconditionally prints a given message and stops execution. 콘솔에 주어진 메시지를 출력하고 실행시 앱 실행을 중지하는 방법이다. 오류는 디버그하기 쉽도록 파일 이름과 줄 번호를 가지도록 하여 더 구체적이다.
        }
    }
    
    
}
