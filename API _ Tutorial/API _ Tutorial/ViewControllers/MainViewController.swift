//
//  ViewController.swift
//  API _ Tutorial
//
//  Created by Sh Hong on 2021/07/19.
//

import UIKit
import Toast
import Alamofire

class MainViewController: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var segControl: UISegmentedControl!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var showResultBtn: UIButton!
    @IBOutlet var searchIndicator: UIActivityIndicatorView!
    @IBOutlet var containerView: UIView!
    
    var storedDistance : CGFloat?
    let keyboardDismisstapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("MainViewController viewDidLoad called")
        setConstraints()
    }
    
    // 화면이 넘어가기 전에 준비한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("mainVC = prepare() called / segue.identifier : \(segue.identifier)")
        
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면의 VC를 가져온다.
            let nextVC = segue.destination as? UserListVC
            
            guard let userInputValue = self.searchBar.text else { return }
            nextVC?.vcTitle = userInputValue
        default:
            print("default")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        
    }
    
    //MARK: - fileprivate methods
    fileprivate func pushVC() {
        var segueID = ""
        
        switch segControl.selectedSegmentIndex {
        case 0:
            print("사진화면으로 이동")
            segueID = "goToPhotoCollectionVC"
        case 1:
            print("사용자화면으로 이동")
            segueID = "goToUserListVC"
        default:
            print("default")
            segueID = "goToPhotoCollectionVC"
        }
        
        //화면이동
        self.performSegue(withIdentifier: segueID, sender: self)
    }
    
    //MARK : - IBAction methods
    @IBAction func selectSearchFocus(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBar.placeholder = "사진 키워드 입력"
        case 1:
            searchBar.placeholder = "사용자 이름 입력"
        default:
            searchBar.placeholder = "사진 키워드 입력"
        }
        
        self.searchBar.becomeFirstResponder()
        
        
    }
    
    
    @IBAction func resultBtnTapped(_ sender: UIButton) {
        print("MainViewController - resultBtnTapped() called / selected index : \(segControl.selectedSegmentIndex)")
        //화면으로 이동
        //        pushVC()
        //        let url = API.BASE_URL + "search/photos"
        
        //키, 밸류 형식의 딕셔너리
        guard let userInput = self.searchBar.text else { return }
        
        //        let queryParam = ["query" : userInput, "client_id" : API.CLIENT_ID]
        
        //        AF.request(url, method: .get, parameters: queryParam).responseJSON(completionHandler: { response in
        //            debugPrint(response)
        //        })
        
        var urlTocall : URLRequestConvertible?
        
        switch segControl.selectedSegmentIndex {
        case 0:
            urlTocall = MySearchRouter.searchPhotos(term: userInput)
            
            MyAlamofireManager.shared.getPhotos(searchTerm: userInput, completion: { result in
                switch result {
                case .success(let fetchedPhotos) :
                    print("MainVC = getPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                case .failure(let error):
                    print("MainVC = getPhotos.failure - error : \(error.rawValue)")

                }
            })
        case 1:
            urlTocall = MySearchRouter.searchUsers(term: userInput)
        default:
            print("default")
        }
        
//        if let urlConvertible = urlTocall {
//
//            MyAlamofireManager
//                .shared
//                .session
//                .request(urlConvertible)
//                .validate(statusCode: 200...400)
//                .responseJSON(completionHandler: { response in
//                    debugPrint(response)
//                })
//        }
        
    }
    
    
    @IBAction func searchFilterValueChanged(_ sender: Any) {
        print("MainViewController - searchFilterValueChanged called")
    }
    
    //MARK: - relate searchBar method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.resignFirstResponder()
    }
    
}

extension MainViewController {
    //MARK: - SetUpConstraints
    fileprivate func setConstraints() {
        self.view.addGestureRecognizer(keyboardDismisstapGesture)
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = "사진 키워드 입력"
        self.keyboardDismisstapGesture.delegate = self
        
        self.showResultBtn.layer.cornerRadius = 10
        self.showResultBtn.isHidden = true
        
    }
    
    //MARK: - UISearchBar Delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("MainViewController - searchBarSearchButtonClicked() called")
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            self.view.makeToast("🔔검색 키워드를 입력해주세요.", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("MainViewController - searchBar textDidChange() searchText : \(searchText)")
        if searchText.isEmpty {
            self.showResultBtn.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                //포커싱 해제
                searchBar.resignFirstResponder()
            })
            
        } else {
            self.showResultBtn.isHidden = false
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        print("shouldChangeTextIn : \(inputTextCount)")
        
        if inputTextCount >= 12 {
            self.view.makeToast("🔈12자 까지만 입력가능합니다.", duration: 1.0, position: .center)
        }
        
        return inputTextCount <= 12
    }
    
    
    //MARK: - keyboardNotification
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowHandle(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideHandle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil) }
    
    @objc
    private func keyboardWillShowHandle(_ noti: Notification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardOriginY = keyboardRectangle.origin.y
            print("keyboardOriginY : \(keyboardOriginY)")
            let containerViewBottomOriginY = self.containerView.frame.origin.y + self.containerView.frame.height
            print("containerViewBottomOriginY : \(containerViewBottomOriginY)")
            let distanceWithTwoPoint = keyboardOriginY - containerViewBottomOriginY
            if distanceWithTwoPoint < 0 {
                self.view.frame.origin.y += (distanceWithTwoPoint * 1.3)
                self.storedDistance = distanceWithTwoPoint * 1.3
            }
        }
    }
    
    @objc
    private func keyboardWillHideHandle(_ noti: Notification) {
        self.view.frame.origin.y = 0
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("MainViewController - gestureRecognizer shouldReceive() called")
        
        // 터치로 들어온 뷰의 구분
        if touch.view?.isDescendant(of: segControl) == true {
            print("세그먼트가 터치되었다.")
            return false
        } else if touch.view?.isDescendant(of: searchBar) == true {
            print("서치바가 터치되었다.")
            return false
        } else {
            view.endEditing(true)
            print("화면이 터치되었다.")
            return true
        }
        
    }
}
