//
//  Radar.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/12.
//

import CoreLocation

final class Radar: NSObject {
    
    // MARK: - Static
    
    static let shared = Radar()
    
    // MARK: - Property
    
    private var locationManager: CLLocationManager
    private var authorizedAction: ((CLAuthorizationStatus) -> Void)?
    private var unauthorizedAction: ((CLAuthorizationStatus) -> Void)?
    
    var currentLocation: CLLocation?
    
    // MARK: - Public
    
    func start() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func authorizationStatusActions(authorized authorizedAction: ((CLAuthorizationStatus) -> Void)?, unauthorized unauthorizedAction: ((CLAuthorizationStatus) -> Void)? = nil) {
        self.authorizedAction = authorizedAction
        self.unauthorizedAction = unauthorizedAction
        
        self.authorizationStatusActionsResolver()
    }
    
    func authorizedFilter(_ action: (CLAuthorizationStatus) -> Void) {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            action(self.locationManager.authorizationStatus)
        
        default:
            return
        }
    }
    
    // MARK: - Private
    
    private override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
    }
    
    private func authorizationStatusActionsResolver() {
        switch self.locationManager.authorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            self.authorizedAction?(self.locationManager.authorizationStatus)
            
            self.authorizedAction = nil
            self.unauthorizedAction = nil
        
        default:
            self.unauthorizedAction?(self.locationManager.authorizationStatus)
            
            self.authorizedAction = nil
            self.unauthorizedAction = nil
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension Radar: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatusActionsResolver()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
}
