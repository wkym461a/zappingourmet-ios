//
//  ShopDetailMapView.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/12.
//

import MapKit

final class ShopDetailMapView: MKMapView {
    
    // MARK: - Outlet
    
    // MARK: - Property
    
    private var visibleEdgePadding: UIEdgeInsets {
        return .init(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    func updateUI(destination: CLLocationCoordinate2D) {
        self.removeOverlays(self.overlays)
        
        self.showRoute(destination: destination)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.delegate = self
        self.showsUserLocation = true
        self.layer.cornerRadius = 8
    }
    
    private func showRoute(destination: CLLocationCoordinate2D) {
        self.getRoutesFromCurrentLocation(to: destination) { routes in
            guard let route = routes.first else {
                return
            }
            self.addOverlay(route.polyline, level: .aboveRoads)
            
            self.setVisibleRects(
                edgePadding: self.visibleEdgePadding,
                animated: false
            )
        }
    }
    
    // MARK: - Action
    
}

// MARK: - MKMapViewDelegate

extension ShopDetailMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is MKPolyline:
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = Constant.Color.baseOrange
            renderer.lineWidth = 3.0
            return renderer
            
        default:
            return MKOverlayRenderer()
            
        }
    }
    
}
