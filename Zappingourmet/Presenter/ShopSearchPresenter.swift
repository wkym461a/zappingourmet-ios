//
//  ShopSearchPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import CoreLocation
import Combine

protocol ShopSearchPresentable {
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func getCurrentLocation() -> CLLocation?
    
    func getHotPepperGourmetSearchRange(index: Int) -> HotPepperGourmetSearchRange?
    func getHotPepperGourmetSearchRangesCount() -> Int
    
    func fetchHotPepperGenres()
    func getHotPepperGenre(index: Int) -> Genre
    func getHotPepperGenresCount() -> Int
    
    func authorizationStatusActions(authorized: ((CLAuthorizationStatus) -> Void)?, unauthorized: ((CLAuthorizationStatus) -> Void)?)
    func authorizedFilter(_ action: ((CLAuthorizationStatus) -> Void))
    
}

final class ShopSearchPresenter {
    
    private weak var view: ShopSearchViewable?
    private var genres: [Genre]
    
    private var cancellable: AnyCancellable?
    
    init(_ view: ShopSearchViewable) {
        self.view = view
        self.genres = []
    }
    
}

// MARK: - ShopSearchPresentable

extension ShopSearchPresenter: ShopSearchPresentable {
    
    func startUpdatingLocation() {
        Radar.shared.start()
    }
    
    func stopUpdatingLocation() {
        Radar.shared.stop()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return Radar.shared.currentLocation
    }
    
    func getHotPepperGourmetSearchRange(index: Int) -> HotPepperGourmetSearchRange? {
        return HotPepperGourmetSearchRange.allCases[index]
    }
    
    func getHotPepperGourmetSearchRangesCount() -> Int {
        return HotPepperGourmetSearchRange.allCases.count
    }
    
    func fetchHotPepperGenres() {
        self.cancellable = HotPepperAPI.shared.request(
            target: HotPepperGenreMaster()
            
        ).sink { completion in
            print("HotPepperAPI.GenreMaster", completion)
            
        } receiveValue: { response in
            let results = response.results
            if let error = results.error {
                error.forEach {
                    print("HOT PEPPER API Error: \($0.message) (code: \($0.code)")
                }
                return
            }
            
            guard
                let hpGenres = results.genre,
                let _ = results.resultsAvailable,
                let _ = results.resultsReturned,
                let _ = results.resultsStart
            
            else {
                fatalError("Unexpect Error: Unknown Response \(results)")
            }
            
            self.genres = hpGenres.map { Genre.fromHotPepperGenre($0) }
            self.genres.insert(Genre.none, at: 0)
            
            self.view?.updateUI()
        }
    }
    
    func getHotPepperGenre(index: Int) -> Genre {
        return self.genres[index]
    }
    
    func getHotPepperGenresCount() -> Int {
        return self.genres.count
    }
    
    func authorizationStatusActions(authorized: ((CLAuthorizationStatus) -> Void)?, unauthorized: ((CLAuthorizationStatus) -> Void)? = nil) {
        Radar.shared.authorizationStatusActions(authorized: authorized, unauthorized: unauthorized)
    }
    
    func authorizedFilter(_ action: ((CLAuthorizationStatus) -> Void)) {
        Radar.shared.authorizedFilter(action)
    }
    
}
