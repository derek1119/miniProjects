//
//  DetailViewController.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var memoTableView: UITableView!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    var token : NSObjectProtocol?
    //노티피케이션 토큰 저장
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    //옵저버 해제 코드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.memoTableView.reloadData()
        })

    }
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo)
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        //어떤 버튼을 선택하든 항상 경고창이 자동으로 사라지기 때문에 경고창을 닫는 코드는 직접 구현할 필요가 없기 때문에 핸들러에 nil을 전달함
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        
        guard let memo = memo?.content else { return }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
        
        if let pc = vc.popoverPresentationController {
            pc.barButtonItem = sender
        }
    }
    //이 3줄의 코드로 공유기능 완성 나머지느 iOS가 알아서 처리함
    
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
