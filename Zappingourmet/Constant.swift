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
    }
    
    struct StoryboardInitialViewController {
        static let ShopSearch = UIStoryboard(name: "ShopSearch", bundle: nil).instantiateInitialViewController()!
        static let ShopList = UIStoryboard(name: "ShopList", bundle: nil).instantiateInitialViewController()!
        static let ShopDetail = UIStoryboard(name: "ShopDetail", bundle: nil).instantiateInitialViewController()!
    }
    
}
