//
//  ExString.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/12.
//

import UIKit

extension String {
    
    var underlined: NSAttributedString {
        let attributedString: NSMutableAttributedString = .init(string: self)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: .init(location: 0, length: self.count)
        )
        return attributedString
    }
    
}
