//
//  ExUIViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/12.
//

import UIKit

extension UIViewController {
    
    func openURLSafely(_ url: URL?, failed alert: UIAlertController? = nil) {
        guard
            let url = url,
            UIApplication.shared.canOpenURL(url)
                
        else {
            if let alert = alert {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        UIApplication.shared.open(url)
    }
    
}
