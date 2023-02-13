//
//  Constant.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

struct Constant {
    
    static let ShopDetailItemKey = "ShopDetail.shop"
    static let HotPepperGourmetSearchLatitudeKey = "HotPepperGourmetSearch.lat"
    static let HotPepperGourmetSearchLongitudeKey = "HotPepperGourmetSearch.lng"
    static let HotPepperGourmetSearchRangeKey = "HotPepperGourmetSearch.range"
    
    struct Storyboard {
        static let ShopSearch = UIStoryboard(name: "ShopSearch", bundle: nil).instantiateInitialViewController()!
        static let ShopList = UIStoryboard(name: "ShopList", bundle: nil).instantiateInitialViewController()!
        static let ShopDetail = UIStoryboard(name: "ShopDetail", bundle: nil).instantiateInitialViewController()!
    }
    
}
