//
//  ShopListPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Foundation
import Combine
import CoreLocation

struct ShopListPresenterFetchShopsParams {
    
    static let `default` = ShopListPresenterFetchShopsParams(
        latitude: 35.68385063,
        longitude: 139.75397279,
        searchRange: .oneThousandMeters,
        genre: nil
    )
    
    let latitude: Double
    let longitude: Double
    let searchRange: HotPepperGourmetSearchRange?
    let genre: Genre?
    
}

protocol ShopListPresentable: AnyObject {
    
    func fetchShops()
    func getShopsCount() -> Int
    func getShop(index: Int) -> Shop
    
    func getFetchShopsParamSearchRange() -> HotPepperGourmetSearchRange?
    func getFetchShopsParamGenre() -> Genre?
    func getAvailableShopsCount() -> Int
    func getIsFetchedAllAvailableShops() -> Bool
    
}

final class ShopListPresenter {
    
    private weak var view: ShopListViewable?
    private var fetchShopsParams: ShopListPresenterFetchShopsParams
    private var shops: [Shop]
    
    private var isFetching: Bool = false
    private var cancellable: AnyCancellable?
    private var availableShopsCount: Int?
    private var fetchStartIndex: Int = 1
    private let fetchCount: Int = 10
    private var isFetchedAllAvailableShops: Bool = false
    
    init(_ view: ShopListViewable, fetchShopsParams: ShopListPresenterFetchShopsParams?) {
        self.view = view
        self.fetchShopsParams = fetchShopsParams ?? .default
        
        self.shops = []
    }
    
}

// MARK: - ShopListPresentable

extension ShopListPresenter: ShopListPresentable {
    
    func fetchShops() {
        if let count = self.availableShopsCount, count < self.fetchStartIndex {
            return
        }
        
        if self.isFetching {
            return
        }
        self.isFetching = true
        
        self.cancellable = HotPepperAPI.shared.request(
            target: HotPepperGourmetSearch(
                lat: self.fetchShopsParams.latitude,
                lng: self.fetchShopsParams.longitude,
                range: self.fetchShopsParams.searchRange,
                genre: self.getFetchShopsParamGenre()?.code,
                start: self.fetchStartIndex,
                count: self.fetchCount
            )
        ).sink { completion in
            print("HotPepperAPI.GourmetSearch", completion)
            
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
            
            if self.availableShopsCount == nil {
                self.availableShopsCount = resultsAvailable
            }
            
            self.fetchStartIndex = resultsStart + (Int(resultsReturned) ?? hpShops.count)
            
            if resultsAvailable < self.fetchStartIndex || resultsAvailable == 0 {
                self.isFetchedAllAvailableShops = true
            }
            
            self.isFetching = false
        }
    }
    
    func getShopsCount() -> Int {
        return self.shops.count
    }
    
    func getShop(index: Int) -> Shop {
        return self.shops[index]
    }
    
    func getFetchShopsParamSearchRange() -> HotPepperGourmetSearchRange? {
        return self.fetchShopsParams.searchRange
    }
    
    func getFetchShopsParamGenre() -> Genre? {
        return (self.fetchShopsParams.genre?.code != Genre.none.code) ? self.fetchShopsParams.genre : nil
    }
    
    func getAvailableShopsCount() -> Int {
        return self.availableShopsCount ?? 0
    }
    
    func getIsFetchedAllAvailableShops() -> Bool {
        return self.isFetchedAllAvailableShops
    }
    
}
