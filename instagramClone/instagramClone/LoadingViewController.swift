//
//  LoadingViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/11.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
    
    // MARK: - Properties
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballSpinFadeLoader, color: .black, padding: nil)
    
    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).then {
        $0.alpha = 0.8
        $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        blurEffectView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        loadingIndicator.stopAnimating()
    }
}
