//
//  Constant.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

struct Constant {
    
    struct Color {
        static let baseOrange = UIColor.dynamicColor(
            light: .init(red: 238 / 255, green: 128 / 255, blue: 16 / 255, alpha: 1.0),
            dark: .init(red: 225 / 255, green: 126 / 255, blue: 27 / 255, alpha: 1.0)
        )
    }
    
    static let creditURL = URL(string: "http://webservice.recruit.co.jp/")
    
}
