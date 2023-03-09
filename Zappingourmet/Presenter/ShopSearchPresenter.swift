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
    
    func getHotPepperGourmetSearchRange(index: Int) -> HotPepperGourmetSearchRange?
    func getHotPepperGourmetSearchRangesCount() -> Int
    
    func fetchHotPepperGenres()
    func getHotPepperGenre(index: Int) -> Genre
    func getHotPepperGenresCount() -> Int
    
    func locationManagerAuthStatusActions(authorized authAction: ((CLAuthorizationStatus) -> Void)?, unauthorized unauthAction: ((CLAuthorizationStatus?) -> Void)?)
    func locationManagerAuthFilter(authorized authAction: ((CLAuthorizationStatus) -> Void)?)
    
}

final class ShopSearchPresenter: NSObject {
    
    private weak var view: ShopSearchViewable?
    private var genres: [Genre]
    
    private var cancellable: AnyCancellable?
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    
    private var locationManagerAuthorizedAction: ((CLAuthorizationStatus) -> Void)?
    private var locationManagerUnauthorizedAction: ((CLAuthorizationStatus?) -> Void)?
    
    init(_ view: ShopSearchViewable) {
        self.view = view
        
        self.genres = []
    }
    
    private func locationManagerAuthStatusActionsResolver() {
        switch self.locationManager?.authorizationStatus {
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager?.startUpdatingLocation()
            self.locationManagerAuthorizedAction?(self.locationManager!.authorizationStatus)
            
            self.locationManagerAuthorizedAction = nil
            self.locationManagerUnauthorizedAction = nil
        
        default:
            self.locationManagerUnauthorizedAction?(self.locationManager?.authorizationStatus)
            
            self.locationManagerAuthorizedAction = nil
            self.locationManagerUnauthorizedAction = nil
        }
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
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return self.currentLocation
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
    
    func locationManagerAuthStatusActions(authorized authAction: ((CLAuthorizationStatus) -> Void)?, unauthorized unauthAction: ((CLAuthorizationStatus?) -> Void)? = nil) {
        self.locationManagerAuthorizedAction = authAction
        self.locationManagerUnauthorizedAction = unauthAction
        
        self.locationManagerAuthStatusActionsResolver()
    }
    
    func locationManagerAuthFilter(authorized authAction: ((CLAuthorizationStatus) -> Void)?) {
        switch self.locationManager?.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authAction?(self.locationManager!.authorizationStatus)
        
        default:
            return
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension ShopSearchPresenter: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationManagerAuthStatusActionsResolver()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.first
        
        self.view?.updateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
}
