//
//  ShopListPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Foundation
import Combine
import CoreLocation

protocol ShopListPresentable: AnyObject {
    
    func fetchShops()
    func getShopsCount() -> Int
    func getShop(index: Int) -> Shop
    func setShopDetailItem(index: Int)
    
    func getSearchRangeName() -> String?
    
}

final class ShopListPresenter {
    
    private weak var view: ShopListViewable?
    private var shops: [Shop]
    
    private var isFetching: Bool = false
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
        
        if self.isFetching {
            return
        }
        self.isFetching = true
        
        let searchRangeIndex = UserDefaults.standard.integer(forKey: Constant.UserDefaultsReservedKey.SearchRange_Int)
        self.cancellable = HotPepperAPI.shared.request(
            target: HotPepperGourmetSearch(
                lat: UserDefaults.standard.double(forKey: Constant.UserDefaultsReservedKey.SearchLatitude_Double),
                lng: UserDefaults.standard.double(forKey: Constant.UserDefaultsReservedKey.SearchLongitude_Double),
                range: HotPepperGourmetSearchRange.allCases[searchRangeIndex],
                start: self.fetchStartIndex,
                count: self.fetchCount
            )
        ).sink { completion in
            print(completion)
            
            self.isFetching = false

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
            
            self.isFetching = false
        }
    }
    
    func getShopsCount() -> Int {
        return self.shops.count
    }
    
    func getShop(index: Int) -> Shop {
        return self.shops[index]
    }
    
    func setShopDetailItem(index: Int) {
        UserDefaults.standard.save(self.shops[index], key: Constant.UserDefaultsReservedKey.ShopDetailItem_Shop)
    }
    
    func getSearchRangeName() -> String? {
        let searchRangeIndex = UserDefaults.standard.integer(forKey: Constant.UserDefaultsReservedKey.SearchRange_Int)
        return HotPepperGourmetSearchRange.allCases[searchRangeIndex].name
    }
    
}
