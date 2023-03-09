//
//  ExUIAlertController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/09.
//

import UIKit

extension UIAlertController {
    
    static func messageAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
        alertController.addAction(closeAction)
        
        return alertController
    }
    
    static func confirmActionAlert(title: String, message: String, confirmTitle: String, confirmHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let openSettingsAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
        alertController.addAction(openSettingsAction)
        
        let closeAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        
        return alertController
    }
    
}
