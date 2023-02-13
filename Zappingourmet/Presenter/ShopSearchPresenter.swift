//
//  ShopSearchPresenter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import Foundation
import CoreLocation

protocol ShopSearchPresentable: AnyObject {
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func getCurrentLocation() -> CLLocation?
    func getHotPepperGourmetSearchRangeName(index: Int) -> String?
    func getHotPepperGourmetSearchRangesCount() -> Int
    func getHotPepperGourmetSearchRangeValue(index: Int) -> Int?
    
    func setHotPepperGourmetSearchCoordinate()
    func setHotPepperGourmetSearchRange(selectedIndex: Int)
    
}

final class ShopSearchPresenter: NSObject {
    
    private weak var view: ShopSearchViewable?
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    
    init(_ view: ShopSearchViewable) {
        self.view = view
    }
    
}

// MARK: - ShopSearchPresentable

extension ShopSearchPresenter: ShopSearchPresentable {
    
    func startUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
        
        self.locationManager = CLLocationManager()
        
        self.locationManager?.requestWhenInUseAuthorization()
        
        switch locationManager?.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager?.delegate = self
            self.locationManager?.startUpdatingLocation()
            
        default:
            return
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
    
    func setHotPepperGourmetSearchCoordinate() {
        if let location = self.currentLocation {
            UserDefaults.standard.set(Double(location.coordinate.latitude), forKey: Constant.HotPepperGourmetSearchLatitudeKey)
            UserDefaults.standard.set(Double(location.coordinate.longitude), forKey: Constant.HotPepperGourmetSearchLongitudeKey)
        }
    }
    
    func setHotPepperGourmetSearchRange(selectedIndex: Int) {
        UserDefaults.standard.set(selectedIndex, forKey: Constant.HotPepperGourmetSearchRangeKey)
    }
    
}

// MARK: - CLLocationManagerDelegate

extension ShopSearchPresenter: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.first
        
        if let location = self.currentLocation {
            print("currentLocation: { lat: \(location.coordinate.latitude), lng: \(location.coordinate.longitude) }")
            
        } else {
            print("currentLocation: nil")
        }
        
        self.view?.updateUI()
    }
    
}
