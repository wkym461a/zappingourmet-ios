//
//  ExMKMapView.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/10.
//

import MapKit

extension MKMapView {
    
    func setVisibleOverlays(edgePadding: UIEdgeInsets, animated: Bool) {
        if let firstOverlay = self.overlays.filter({ $0 is MKCircle }).first {
            let rect = self.overlays.reduce(firstOverlay.boundingMapRect, { $0.union($1.boundingMapRect) })
            self.setVisibleMapRect(rect, edgePadding: edgePadding, animated: animated)
        }
    }

    func getRoutes(from startPoint: CLLocationCoordinate2D, to endPoint: CLLocationCoordinate2D, completion: (([MKRoute]) -> Void)? = nil) {
        var region = self.region
        region.center = endPoint
        region.span = .init(
            latitudeDelta: .init(0.02),
            longitudeDelta: .init(0.02)
        )
        self.region = region

        let annotation = MKPointAnnotation()
        annotation.coordinate = endPoint
        self.addAnnotation(annotation)

        let startPlacemark: MKMapItem = .init(
            placemark: MKPlacemark(
                coordinate: startPoint,
                addressDictionary: nil
            )
        )
        let endPlacemark: MKMapItem = .init(
            placemark: MKPlacemark(
                coordinate: endPoint,
                addressDictionary: nil
            )
        )

        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .walking
        directionsRequest.source = startPlacemark
        directionsRequest.destination = endPlacemark

        let direction = MKDirections(request: directionsRequest)
        direction.calculate { response, error in
            if let error = error {
                print(#function, error)
                return
            }
            
            guard let routes = response?.routes else {
                print(#function, "response.routes not found")
                return
            }
            
            completion?(routes)
        }
    }
    
    func getRoutesFromCurrentLocation(to endPoint: CLLocationCoordinate2D, completion: (([MKRoute]) -> Void)? = nil) {
        self.getRoutes(from: self.userLocation.coordinate, to: endPoint, completion: completion)
    }

}
