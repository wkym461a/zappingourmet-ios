//
//  Shop.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Foundation

struct Shop: Codable {
    
    static let `default` = Shop(
        id: "J999999999",
        name: "居酒屋 ホットペッパー",
        address: "東京都中央区銀座８－４－１７",
        access: "銀座駅A2出口でて､みゆき通り右折､徒歩1分",
        photoURL: URL(string: "https://webservice.recruit.co.jp/doc/hotpepper/reference.html")!,
        open: "月～金／11：30～14：00",
        close: "日"
    )
    
    static func fromHotPepperShop(_ shop: HotPepperGourmetSearchResults.Shop) -> Self {
        let photoURL = shop.photo.pc.l
        let open = shop.open ?? ""
        let close = shop.close ?? ""
        
        return Shop(
            id: shop.id,
            name: shop.name,
            address: shop.address,
            access: shop.access,
            photoURL: photoURL,
            open: open,
            close: close
        )
    }
    
    var id: String
    var name: String
    var address: String
    var access: String
    var photoURL: URL
    var open: String
    var close: String
    
}
