//
//  ShopDetailPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import Foundation

protocol ShopDetailPresentable: AnyObject {
    
    func getItem() -> Shop
    
}

final class ShopDetailPresenter {
    
    private weak var view: ShopDetailViewable?
    private var item: Shop
    
    init(_ view: ShopDetailViewable, item: Shop?) {
        self.view = view
        
        self.item = item ?? .default
    }
    
}

// MARK: - ShopDetailPresentable

extension ShopDetailPresenter: ShopDetailPresentable {
    
    func getItem() -> Shop {
        return self.item
    }
    
}
