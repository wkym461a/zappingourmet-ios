//
//  ShopSearchPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import CoreLocation
import Combine

protocol ShopSearchPresentable {
    
    func getHotPepperGourmetSearchRange(index: Int) -> HotPepperGourmetSearchRange?
    func getHotPepperGourmetSearchRangesCount() -> Int
    func getSelectedSearchRange() -> HotPepperGourmetSearchRange
    func updateSelectedSearchRange(index: Int)
    
    func fetchHotPepperGenres()
    func getHotPepperGenre(index: Int) -> Genre?
    func getHotPepperGenresCount() -> Int
    func getSelectedGenre() -> Genre
    func updateSelectedGenre(index: Int)
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func getCurrentLocation() -> CLLocation?
    func authorizationStatusActions(authorized: ((CLAuthorizationStatus) -> Void)?, unauthorized: ((CLAuthorizationStatus) -> Void)?)
    func authorizedFilter(_ action: ((CLAuthorizationStatus) -> Void))
    
}

final class ShopSearchPresenter {
    
    private weak var view: ShopSearchViewable?
    private var selectedSearchRangeIndex: Int
    private var selectedGenreIndex: Int
    private var genres: [Genre]
    
    private var cancellable: AnyCancellable?
    
    init(_ view: ShopSearchViewable, selectedSearchRangeIndex: Int = 0, selectedGenreIndex: Int = 0) {
        self.view = view
        self.selectedSearchRangeIndex = selectedSearchRangeIndex
        self.selectedGenreIndex = selectedGenreIndex
        self.genres = [.none]
    }
    
}

// MARK: - ShopSearchPresentable

extension ShopSearchPresenter: ShopSearchPresentable {
    
    func getHotPepperGourmetSearchRange(index: Int) -> HotPepperGourmetSearchRange? {
        guard 0 ..< HotPepperGourmetSearchRange.allCases.count ~= index else {
            return nil
        }
        
        return HotPepperGourmetSearchRange.allCases[index]
    }
    
    func getHotPepperGourmetSearchRangesCount() -> Int {
        return HotPepperGourmetSearchRange.allCases.count
    }
    
    func getSelectedSearchRange() -> HotPepperGourmetSearchRange {
        return HotPepperGourmetSearchRange.allCases[self.selectedSearchRangeIndex]
    }
    
    func updateSelectedSearchRange(index: Int) {
        guard 0 ..< HotPepperGourmetSearchRange.allCases.count ~= index else {
            return
        }
        
        self.selectedSearchRangeIndex = index
        self.view?.updateUI(
            selectedSearchRange: HotPepperGourmetSearchRange.allCases[self.selectedSearchRangeIndex],
            selectedGenre: nil
        )
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
            self.genres.insert(.none, at: 0)
            
            self.view?.updateUI(
                selectedSearchRange: HotPepperGourmetSearchRange.allCases[self.selectedSearchRangeIndex],
                selectedGenre: self.genres[self.selectedGenreIndex]
            )
        }
    }
    
    func getHotPepperGenre(index: Int) -> Genre? {
        guard 0 ..< self.genres.count ~= index else {
            return nil
        }
        
        return self.genres[index]
    }
    
    func getHotPepperGenresCount() -> Int {
        return self.genres.count
    }
    
    func getSelectedGenre() -> Genre {
        return self.genres[self.selectedGenreIndex]
    }
    
    func updateSelectedGenre(index: Int) {
        guard 0 ..< self.genres.count ~= index else {
            return
        }
        
        self.selectedGenreIndex = index
        self.view?.updateUI(
            selectedSearchRange: nil,
            selectedGenre: self.genres[self.selectedGenreIndex]
        )
    }
    
    func startUpdatingLocation() {
        Radar.shared.start()
    }
    
    func stopUpdatingLocation() {
        Radar.shared.stop()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return Radar.shared.currentLocation
    }
    
    func authorizationStatusActions(authorized: ((CLAuthorizationStatus) -> Void)?, unauthorized: ((CLAuthorizationStatus) -> Void)? = nil) {
        Radar.shared.authorizationStatusActions(authorized: authorized, unauthorized: unauthorized)
    }
    
    func authorizedFilter(_ action: ((CLAuthorizationStatus) -> Void)) {
        Radar.shared.authorizedFilter(action)
    }
    
}
