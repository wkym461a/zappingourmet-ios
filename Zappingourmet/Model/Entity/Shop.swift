//
//  Shop.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Foundation

struct Shop: Codable {
    
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
