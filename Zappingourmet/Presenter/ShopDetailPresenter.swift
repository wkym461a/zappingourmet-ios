//
//  ShopDetailPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import Foundation

protocol ShopDetailPresentable: AnyObject {
    
    func getItem() -> Shop
    func removeShopDetailItem()
    
}

final class ShopDetailPresenter {
    
    private weak var view: ShopDetailViewable?
    private var item: Shop
    
    init(_ view: ShopDetailViewable) {
        self.view = view
        
        self.item = UserDefaults.standard.load(Shop.self, key: Constant.UserDefaultsReservedKey.ShopDetailItem_Shop) ?? .default
    }
    
}

// MARK: - ShopDetailPresentable

extension ShopDetailPresenter: ShopDetailPresentable {
    
    func getItem() -> Shop {
        return self.item
    }
    
    func removeShopDetailItem() {
        UserDefaults.standard.removeObject(forKey: Constant.UserDefaultsReservedKey.ShopDetailItem_Shop)
    }
    
}
