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
    @IBOutlet private weak var rangeValueLabel: UILabel!
    
    @IBOutlet private weak var searchButton: UIButton!
    
    // MARK: - Property
    
    private var presenter: ShopSearchPresentable?
    private var circle: MKCircle?
    
    private var isInitializedMapView: Bool = false
    
    private var mapViewOverlaysEdgePadding: UIEdgeInsets {
        return .init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
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
        
        self.centeringCurrentLocationButton.backgroundColor = Constant.Color.baseOrange
        self.centeringCurrentLocationButton.layer.cornerRadius = 32
        self.centeringCurrentLocationButton.layer.shadowOffset = .init(width: 0.0, height: 2.0)
        self.centeringCurrentLocationButton.layer.shadowColor = UIColor.black.cgColor
        self.centeringCurrentLocationButton.layer.shadowOpacity = 0.6
        self.centeringCurrentLocationButton.layer.shadowRadius = 4
        
        self.rangePickerControl.layer.cornerRadius = 8
        self.rangePickerControl.layer.borderWidth = 2
        self.rangePickerControl.dataSource = self
        self.rangePickerControl.delegate = self
        self.rangeValueLabel.text = self.presenter?.getHotPepperGourmetSearchRangeName(index: 0)
        
        self.searchButton.layer.cornerRadius = 8
        self.searchButton.backgroundColor = Constant.Color.baseOrange
    }
    
    private func refreshMapViewOverlays() {
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let rangeValue = self.presenter?.getHotPepperGourmetSearchRangeValue(index: self.rangePickerControl.getPickerSelectedRow(inComponent: 0)) ?? 0
        let circle = MKCircle(
            center: self.mapView.userLocation.coordinate,
            radius: CLLocationDistance(rangeValue)
        )
        self.mapView.addOverlay(circle)
    }
    
    private func setVisibleMapViewOverlays(animated: Bool) {
        if let firstOverlay = self.mapView.overlays.filter({ $0 is MKCircle }).first {
            let rect = self.mapView.overlays.reduce(firstOverlay.boundingMapRect, { $0.union($1.boundingMapRect) })
            self.mapView.setVisibleMapRect(rect, edgePadding: self.mapViewOverlaysEdgePadding, animated: animated)
        }
    }
    
    private func goShopList() {
        let shopList = UIStoryboard(name: Constant.StoryboardName.ShopList, bundle: nil).instantiateInitialViewController()!
        self.navigationController?.pushViewController(shopList, animated: true)
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
        self.setVisibleMapViewOverlays(animated: true)
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
        
        self.refreshMapViewOverlays()
        
        if !self.isInitializedMapView {
            self.setVisibleMapViewOverlays(animated: false)
            
            self.isInitializedMapView = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is MKCircle:
            let circleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
            circleView.fillColor = Constant.Color.baseOrange
            circleView.alpha = 0.4
            return circleView
        
        default:
            return MKOverlayRenderer()
        }
    }
    
}

// MARK: - UIPickerViewDataSource

extension ShopSearchViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.presenter?.getHotPepperGourmetSearchRangesCount() ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.presenter?.getHotPepperGourmetSearchRangeName(index: row)
    }
    
}

// MARK: - UIPickerViewDelegate

extension ShopSearchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.rangeValueLabel.text = self.presenter?.getHotPepperGourmetSearchRangeName(index: row)
        
        self.refreshMapViewOverlays()
        self.setVisibleMapViewOverlays(animated: true)
    }
    
}
