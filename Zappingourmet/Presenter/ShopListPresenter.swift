//
//  ShopListPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Combine

protocol ShopListPresentable: AnyObject {
    
    func fetchShops()
    func getShopsCount() -> Int
    func getShop(index: Int) -> Shop
    
}

final class ShopListPresenter {
    
    private weak var view: ShopListViewable?
    private var shops: [Shop]
    private var cancellable: AnyCancellable?
    
    init(_ view: ShopListViewable) {
        self.view = view
        
        self.shops = []
    }
    
}

// MARK: - ShopListPresentable

extension ShopListPresenter: ShopListPresentable {
    
    func fetchShops() {
        self.cancellable = HotPepperAPI.shared.request(
            target: HotPepperGourmetSearch(
                lat: 35.17454481366307,
                lng: 136.91228418325178,
                start: 1,
                count: 100
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
            
            guard let hpShops = results.shop else {
                fatalError("Unexpect Error: Unknown Response \(results)")
            }
            
            self.shops = hpShops.map { Shop.fromHotPepperShop($0) }
            
            self.view?.updateUI()
        }
    }
    
    func getShopsCount() -> Int {
        return self.shops.count
    }
    
    func getShop(index: Int) -> Shop {
        return self.shops[index]
    }
    
}
