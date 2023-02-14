//
//  ExUIColor.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/14.
//

import UIKit

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13, *) else {
            return light
        }
        
        return UIColor { ($0.userInterfaceStyle == .dark) ? dark : light }
    }
    
}
