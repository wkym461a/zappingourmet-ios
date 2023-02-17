//
//  ShopSearchPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import Foundation
import CoreLocation
import Combine

protocol ShopSearchPresentable: AnyObject {
    
    func setupLocationManager()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func getCurrentLocation() -> CLLocation?
    
    func getHotPepperGourmetSearchRangeName(index: Int) -> String?
    func getHotPepperGourmetSearchRangesCount() -> Int
    func getHotPepperGourmetSearchRangeValue(index: Int) -> Int?
    
    func fetchHotPepperGenres()
    func getHotPepperGenre(index: Int) -> Genre
    func getHotPepperGenresCount() -> Int
    
    func setHotPepperGourmetSearchCoordinate() -> Bool
    func setHotPepperGourmetSearchRange(selectedIndex: Int)
    func setHotPepperGourmetSearchGenre(selectedIndex: Int)
    
    func locationManagerAuthStatusActions(authorized authAction: ((CLAuthorizationStatus) -> Void)?, unauthorized unauthAction: ((CLAuthorizationStatus?) -> Void)?)
    
}

final class ShopSearchPresenter: NSObject {
    
    private weak var view: ShopSearchViewable?
    private var genres: [Genre]
    
    private var cancellable: AnyCancellable?
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    
    init(_ view: ShopSearchViewable) {
        self.view = view
        
        self.genres = []
    }
    
}

// MARK: - ShopSearchPresentable

extension ShopSearchPresenter: ShopSearchPresentable {
    
    func setupLocationManager() {
        if self.locationManager != nil {
            return
        }
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
    }
    
    func startUpdatingLocation() {
        self.locationManagerAuthStatusActions { _ in
            self.locationManager?.startUpdatingLocation()
            
        } unauthorized: { _ in
            self.view?.openSettings()
        }
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return self.currentLocation
    }
    
    func getHotPepperGourmetSearchRangeName(index: Int) -> String? {
        return HotPepperGourmetSearchRange.allCases[index].name
    }
    
    func getHotPepperGourmetSearchRangesCount() -> Int {
        return HotPepperGourmetSearchRange.allCases.count
    }
    
    func getHotPepperGourmetSearchRangeValue(index: Int) -> Int? {
        return HotPepperGourmetSearchRange.allCases[index].rangeValue
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
    
    func setHotPepperGourmetSearchCoordinate() -> Bool {
        if let location = self.currentLocation {
            UserDefaults.standard.set(Double(location.coordinate.latitude), forKey: Constant.UserDefaultsReservedKey.SearchLatitude_Double)
            UserDefaults.standard.set(Double(location.coordinate.longitude), forKey: Constant.UserDefaultsReservedKey.SearchLongitude_Double)
            
            return true
        
        } else {
            return false
        }
    }
    
    func setHotPepperGourmetSearchRange(selectedIndex: Int) {
        UserDefaults.standard.set(HotPepperGourmetSearchRange.allCases[selectedIndex].code, forKey: Constant.UserDefaultsReservedKey.SearchRange_Int)
    }
    
    func setHotPepperGourmetSearchGenre(selectedIndex: Int) {
        UserDefaults.standard.save(self.genres[selectedIndex], key: Constant.UserDefaultsReservedKey.SearchGenre_Genre)
    }
    
    func locationManagerAuthStatusActions(authorized authAction: ((CLAuthorizationStatus) -> Void)?, unauthorized unauthAction: ((CLAuthorizationStatus?) -> Void)? = nil) {
        switch self.locationManager?.authorizationStatus {
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            authAction?(self.locationManager!.authorizationStatus)
        
        default:
            unauthAction?(self.locationManager?.authorizationStatus)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension ShopSearchPresenter: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.first
        
        self.view?.updateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
}
