//
//  Constant.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

struct Constant {
    
    struct UserDefaultsReservedKey {
        static let ShopDetailItem_Shop = "ShopDetail.shop"
        static let SearchLatitude_Double = "HotPepperGourmetSearch.lat"
        static let SearchLongitude_Double = "HotPepperGourmetSearch.lng"
        static let SearchRange_Int = "HotPepperGourmetSearch.range"
        static let SearchGenre_Genre = "HotPepperGourmetSearch.genre"
    }
    
    struct StoryboardName {
        static let ShopSearch = "ShopSearch"
        static let ShopList = "ShopList"
        static let ShopDetail = "ShopDetail"
    }
    
    struct Color {
        static let baseOrange = UIColor.dynamicColor(
            light: .init(red: 238 / 255, green: 128 / 255, blue: 16 / 255, alpha: 1.0),
            dark: .init(red: 225 / 255, green: 126 / 255, blue: 27 / 255, alpha: 1.0)
        )
    }
    
    static let creditURL = URL(string: "http://webservice.recruit.co.jp/")
    
}
