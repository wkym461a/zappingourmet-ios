//
//  ShopListPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Foundation
import Combine

protocol ShopListPresentable: AnyObject {
    
    func fetchShops()
    func getShopsCount() -> Int
    func getShop(index: Int) -> Shop
    func setShopDetailItem(index: Int)
    
}

final class ShopListPresenter {
    
    private weak var view: ShopListViewable?
    private var shops: [Shop]
    
    private var cancellable: AnyCancellable?
    private var totalShopsCount: Int?
    private var fetchStartIndex: Int = 1
    private let fetchCount: Int = 10
    
    init(_ view: ShopListViewable) {
        self.view = view
        
        self.shops = []
    }
    
}

// MARK: - ShopListPresentable

extension ShopListPresenter: ShopListPresentable {
    
    func fetchShops() {
        if let count = self.totalShopsCount, count < self.fetchStartIndex {
            return
        }
        
        self.cancellable = HotPepperAPI.shared.request(
            target: HotPepperGourmetSearch(
                lat: 35.17454481366307,
                lng: 136.91228418325178,
                start: self.fetchStartIndex,
                count: self.fetchCount
            )
        ).sink { completion in
            print(completion)

        } receiveValue: { response in
            let results = response.results
            if let error = results.error {
                error.forEach {
                    print("HOT PEPPER API Error: \($0.message) (code: \($0.code)")
                }
                return
            }
            
            guard
                let hpShops = results.shop,
                let resultsAvailable = results.resultsAvailable,
                let resultsReturned = results.resultsReturned,
                let resultsStart = results.resultsStart
            
            else {
                fatalError("Unexpect Error: Unknown Response \(results)")
            }
            
            self.shops.append(contentsOf: hpShops.map { Shop.fromHotPepperShop($0) })
            self.view?.updateUI()
            
            if self.totalShopsCount == nil {
                self.totalShopsCount = resultsAvailable
            }
            
            self.fetchStartIndex = resultsStart + (Int(resultsReturned) ?? hpShops.count)
        }
    }
    
    func getShopsCount() -> Int {
        return self.shops.count
    }
    
    func getShop(index: Int) -> Shop {
        return self.shops[index]
    }
    
    func setShopDetailItem(index: Int) {
        UserDefaults.standard.save(self.shops[index], key: Constant.ShopDetailItemKey)
    }
    
}
