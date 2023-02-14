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
    
    @IBOutlet private weak var genrePickerControl: PickerInputControl!
    @IBOutlet private weak var genreValueLabel: UILabel!
    
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
        self.presenter?.fetchHotPepperGenres()
        
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
        
        self.rangePickerControl.picker.tag = 1
        self.rangePickerControl.layer.cornerRadius = 8
        self.rangePickerControl.layer.borderWidth = 2
        self.rangePickerControl.picker.dataSource = self
        self.rangePickerControl.picker.delegate = self
//        self.rangeValueLabel.text = self.presenter?.getHotPepperGourmetSearchRangeName(index: 0)
        
        self.genrePickerControl.picker.tag = 2
        self.genrePickerControl.layer.cornerRadius = 8
        self.genrePickerControl.layer.borderWidth = 2
        self.genrePickerControl.picker.dataSource = self
        self.genrePickerControl.picker.delegate = self
        
        self.searchButton.layer.cornerRadius = 8
        self.searchButton.backgroundColor = Constant.Color.baseOrange
    }
    
    private func refreshMapViewOverlays() {
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let rangeValue = self.presenter?.getHotPepperGourmetSearchRangeValue(index: self.rangePickerControl.picker.selectedRow(inComponent: 0)) ?? 0
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
            selectedIndex: self.rangePickerControl.picker.selectedRow(inComponent: 0)
        )
        self.presenter?.setHotPepperGourmetSearchGenre(
            selectedIndex: self.genrePickerControl.picker.selectedRow(inComponent: 0)
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
        let selectedRangeIndex = self.rangePickerControl.picker.selectedRow(inComponent: 0)
        if let count = self.presenter?.getHotPepperGourmetSearchRangesCount(), count > 0 {
            self.rangeValueLabel.text = self.presenter?.getHotPepperGourmetSearchRangeName(index: selectedRangeIndex)
        }
        
        let selectedGenreIndex = self.genrePickerControl.picker.selectedRow(inComponent: 0)
        if let count = self.presenter?.getHotPepperGenresCount(), count > 0 {
            self.genreValueLabel.text = self.presenter?.getHotPepperGenre(index: selectedGenreIndex).name
        }
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
        switch pickerView.tag {
        case 1:
            return self.presenter?.getHotPepperGourmetSearchRangesCount() ?? 0
        
        case 2:
            return self.presenter?.getHotPepperGenresCount() ?? 0
        
        default:
            return 0
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return self.presenter?.getHotPepperGourmetSearchRangeName(index: row)
            
        case 2:
            return self.presenter?.getHotPepperGenre(index: row).name
            
        default:
            return nil
        }
        
    }
    
}

// MARK: - UIPickerViewDelegate

extension ShopSearchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
//            self.rangeValueLabel.text = self.presenter?.getHotPepperGourmetSearchRangeName(index: row)
            self.updateUI()
            
            self.refreshMapViewOverlays()
            self.setVisibleMapViewOverlays(animated: true)
            
            return
            
        case 2:
            self.updateUI()
            return
            
        default:
            return
        }
        
    }
    
}
