//
//  Extensions.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/12.
//

import UIKit
import SnapKit

extension UIView {
    
    var safeArea: ConstraintBasicAttributesDSL {
#if swift(>=3.2)
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
#else
        return self.snp
#endif
    }
    
}

func Image(_ name: String) -> UIImage? {
    return UIImage(named: name)
}


/*
extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .compactMap({ $0 as? UIWindowScene})
            // Get its associated windows
            .first?.windows
            // Finally, keep only the key window
            .filter { $0.isKeyWindow }.first
    }
    
}
*/
