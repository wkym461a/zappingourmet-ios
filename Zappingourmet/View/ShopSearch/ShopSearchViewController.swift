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
    
    @IBOutlet private weak var rangePickerControl: PickerInputControl!
    @IBOutlet private weak var rangeTitleLabel: UILabel!
    @IBOutlet private weak var rangeValueLabel: UILabel!
    
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
        let gesture: UITapGestureRecognizer = .init(
            target: self,
            action: #selector(self.dismissPickerInput)
        )
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.layer.cornerRadius = 8
        
        self.centeringCurrentLocationButton.layer.cornerRadius = 32
        self.centeringCurrentLocationButton.layer.shadowOffset = .init(width: 0.0, height: 2.0)
        self.centeringCurrentLocationButton.layer.shadowColor = UIColor.black.cgColor
        self.centeringCurrentLocationButton.layer.shadowOpacity = 0.6
        self.centeringCurrentLocationButton.layer.shadowRadius = 4
        
        self.rangePickerControl.layer.cornerRadius = 8
        self.rangePickerControl.layer.borderWidth = 2
        self.rangePickerControl.dataSource = self
        self.rangePickerControl.delegate = self
        self.rangeTitleLabel.text = "検索範囲"
        self.rangeValueLabel.text = Constant.HotPepperGourmetSearchRanges.first
        
        self.searchButton.layer.cornerRadius = 8
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
    
    @objc
    private func dismissPickerInput() {
        self.view.endEditing(true)
    }

    @IBAction private func searchShops(_ sender: UIButton) {
        if let location = self.presenter?.getCurrentLocation() {
            print("ShopSearch: { lat: \(location.coordinate.latitude), lng: \(location.coordinate.longitude) }")
        }
        self.presenter?.setHotPepperGourmetSearchCoordinate()
        self.presenter?.setHotPepperGourmetSearchRange(
            selectedIndex: self.rangePickerControl.getPickerSelectedRow(inComponent: 0)
        )
        
        self.goShopList()
    }
    
    @IBAction private func centeringCurrentLocation(_ sender: UIButton) {
        var region = self.mapView.region
        region.center = self.mapView.userLocation.coordinate
        self.mapView.setRegion(region, animated: true)
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

// MARK: - UIPickerViewDataSource

extension ShopSearchViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.HotPepperGourmetSearchRanges.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.HotPepperGourmetSearchRanges[row]
    }
    
}

// MARK: - UIPickerViewDelegate

extension ShopSearchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.rangeValueLabel.text = Constant.HotPepperGourmetSearchRanges[row]
    }
    
}
