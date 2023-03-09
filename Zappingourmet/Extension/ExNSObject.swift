//
//  ExNSObject.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/09.
//

import Foundation

extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
    
}
