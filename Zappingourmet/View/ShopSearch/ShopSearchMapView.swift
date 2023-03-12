//
//  ShopSearchMapView.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/13.
//

import MapKit

final class ShopSearchMapView: MKMapView {
    
    // MARK: - Outlet
    
    // MARK: - Property
    
    var rangeValue: Int = 0
    
    private var isInitialized: Bool = false
    
    private var visibleEdgePadding: UIEdgeInsets {
        return .init(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    func updateUI(rangeValue: Int) {
        self.removeOverlays(self.overlays)
        
        self.rangeValue = rangeValue
        self.showUserLocationRange()
    }
    
    func refreshVisibleRect(animated: Bool) {
        self.setVisibleRects(
            edgePadding: self.visibleEdgePadding,
            animated: animated
        )
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.delegate = self
        self.showsUserLocation = true
        self.layer.cornerRadius = 8
    }
    
    private func showUserLocationRange() {
        let circle = MKCircle(
            center: self.userLocation.coordinate,
            radius: CLLocationDistance(self.rangeValue)
        )
        self.addOverlay(circle)
    }
    
    // MARK: - Action
    
}

// MARK: - MKMapViewDelegate

extension ShopSearchMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.showUserLocationRange()
        
        if !self.isInitialized {
            self.refreshVisibleRect(animated: false)
            
            self.isInitialized = true
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
