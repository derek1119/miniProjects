//
//  MainViewController.swift
//  RandomLifeQuotes
//
//  Created by Sh Hong on 2021/11/23.
//

import UIKit
import Then
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let textLabel = UITextView().then {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attributedText = NSMutableAttributedString(string: "\n 명언이 들어갈 것입니다. \n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.paragraphStyle: paragraph])
        
        attributedText.append(NSAttributedString(string: "명언가", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: paragraph]))
        
        $0.backgroundColor = .green
        $0.attributedText = attributedText
    }
    
    let randomButton = UIButton(type: .system).then {
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.text = "Random 생성"
        $0.addTarget(self, action: #selector(handleRandomTap), for: .touchUpInside)
        $0.backgroundColor = .red
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        self.view.addSubview(randomButton)
        randomButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - Handlers
    @objc func handleRandomTap() {
        print(#function)
    }
}
