//
//  ShopSearchViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit
import MapKit

protocol ShopSearchViewable: AnyObject {
    
    func updateUI()
    
}

final class ShopSearchViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var centeringCurrentLocationButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    
    // MARK: - Property
    
    private var presenter: ShopSearchPresentable?
    
    private var isSetRegion: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopSearchPresenter(self)
        self.presenter?.startUpdatingLocation()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.layer.cornerRadius = 8
        
        self.centeringCurrentLocationButton.layer.cornerRadius = 32
        self.centeringCurrentLocationButton.layer.shadowOffset = .init(width: 0.0, height: 2.0)
        self.centeringCurrentLocationButton.layer.shadowColor = UIColor.black.cgColor
        self.centeringCurrentLocationButton.layer.shadowOpacity = 0.6
        self.centeringCurrentLocationButton.layer.shadowRadius = 4
        
        self.searchButton.layer.cornerRadius = 16
        self.searchButton.backgroundColor = .systemOrange
    }
    
    private func mapViewSetRegion() {
        var region = self.mapView.region
        region.center = self.mapView.userLocation.coordinate
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        self.mapView.setRegion(region, animated: true)
    }
    
    private func goShopList() {
        let shopList = UIStoryboard(name: "ShopList", bundle: nil).instantiateInitialViewController()!
        self.present(shopList, animated: true, completion: nil)
    }
    
    // MARK: - Action

    @IBAction func searchShops(_ sender: UIButton) {
        if let location = self.presenter?.getCurrentLocation() {
            print("ShopSearch: { lat: \(location.coordinate.latitude), lng: \(location.coordinate.longitude) }")
        }
        self.presenter?.setHotPepperGourmetSearchCoordinate()
        
        self.goShopList()
    }
}

// MARK: - ShopSearchViewable

extension ShopSearchViewController: ShopSearchViewable {
    
    func updateUI() {
    }
    
}

// MARK: - MKMapViewDelegate

extension ShopSearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
        
        if !self.isSetRegion {
            self.mapViewSetRegion()
            
            self.isSetRegion = true
        }
    }
    
}
