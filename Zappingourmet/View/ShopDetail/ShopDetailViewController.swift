//
//  ShopDetailViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit
import MapKit

protocol ShopDetailViewable: AnyObject {
    
    func updateUI()
    
}

final class ShopDetailViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var openLabel: UILabel!
    @IBOutlet private weak var shopURLButton: UIButton!
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var tagCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var accessTitleLabel: UILabel!
    @IBOutlet private weak var accessLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    
    // MARK: - Property
    
    private var presenter: ShopDetailPresentable?
    
    private var mapViewOverlaysEdgePadding: UIEdgeInsets {
        return .init(top: 80, left: 80, bottom: 80, right: 80)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopDetailPresenter(self)
        
        self.setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tagCollectionViewHeightConstraint.constant = self.tagCollectionView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.presenter?.removeShopDetailItem()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        self.contentView.backgroundColor = .clear
        
        self.headerImageView.contentMode = .scaleAspectFill
        
        self.nameLabel.font = .boldSystemFont(ofSize: 24)
        self.nameLabel.numberOfLines = -1
        
        self.openLabel.textColor = .darkGray
        self.openLabel.font = .systemFont(ofSize: 12)
        self.openLabel.numberOfLines = -1
        
        self.shopURLButton.setTitleColor(.systemBlue, for: .normal)
        self.shopURLButton.titleLabel?.font = .systemFont(ofSize: 12)
        self.shopURLButton.titleLabel?.numberOfLines = -1
        
        self.tagCollectionView.dataSource = self
        self.tagCollectionView.delegate = self
        self.tagCollectionView.register(
            UINib(nibName: "ShopDetailTagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "tagCell"
        )
        let layout = ShopDetailTagCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = .zero
        self.tagCollectionView.collectionViewLayout = layout
        
        self.accessTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        self.accessLabel.font = .systemFont(ofSize: 14)
        self.accessLabel.numberOfLines = -1
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.layer.cornerRadius = 8
        self.mapView.clipsToBounds = true
        self.createMapViewRoute()
        
        self.addressLabel.textColor = .darkGray
        self.addressLabel.font = .systemFont(ofSize: 12)
        self.addressLabel.numberOfLines = -1
    }
    
    private func createMapViewRoute() {
        guard let shop = self.presenter?.getItem() else {
            return
        }
        let shopCoordinate: CLLocationCoordinate2D = .init(
            latitude: .init(shop.latitude),
            longitude: .init(shop.longitude)
        )
        let userCoordinate = self.mapView.userLocation.coordinate
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = shopCoordinate
        self.mapView.addAnnotation(annotation)
        
        let userPlacemark: MKMapItem = .init(
            placemark: MKPlacemark(
                coordinate: userCoordinate,
                addressDictionary: nil
            )
        )
        let shopPlacemark: MKMapItem = .init(
            placemark: MKPlacemark(
                coordinate: shopCoordinate,
                addressDictionary: nil
            )
        )
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .walking
        directionsRequest.source = userPlacemark
        directionsRequest.destination = shopPlacemark
        let direction = MKDirections(request: directionsRequest)
        direction.calculate { response, error in
            if let error = error {
                print(#function, error)
                return
            }
            
            guard let route = response?.routes.first else {
                print(#function, "response.routes not found")
                return
            }
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            if let firstOverlay = self.mapView.overlays.first {
                let rect = self.mapView.overlays.reduce(firstOverlay.boundingMapRect, { $0.union($1.boundingMapRect) })
                self.mapView.setVisibleMapRect(rect, edgePadding: self.mapViewOverlaysEdgePadding, animated: false)
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction private func openShopURL(_ sender: Any) {
        guard
            let shopURL = self.presenter?.getItem().url,
            UIApplication.shared.canOpenURL(shopURL)
            
        else {
            print(#function, "failed")
            return
        }
        
        UIApplication.shared.open(shopURL)
    }
    
}

// MARK: - ShopDetailViewable

extension ShopDetailViewController: ShopDetailViewable {
    
    func updateUI() {
        guard let shop = self.presenter?.getItem() else {
            return
        }
        
        self.headerImageView.image = UIImage(data: .fromURL(shop.photoURL))
        self.nameLabel.text = shop.name
        self.openLabel.text = shop.open
        let shopURLString = shop.url.absoluteString
        let attributeShopURLString: NSMutableAttributedString = .init(string: shopURLString)
        attributeShopURLString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: .init(location: 0, length: shopURLString.count)
        )
        self.shopURLButton.setAttributedTitle(attributeShopURLString, for: .normal)
        
        self.accessTitleLabel.text = "アクセス"
        self.accessLabel.text = shop.access
        
        self.addressLabel.text = shop.address
    }
    
}

// MARK: - UICollectionViewDataSource

extension ShopDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter?.getItem().tags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let tag = self.presenter?.getItem().tags[indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? ShopDetailTagCollectionViewCell
                
        else {
            return UICollectionViewCell()
        }
        
        cell.updateUI(tag: tag, maxWidth: collectionView.contentSize.width)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension ShopDetailViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShopDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
}

// MARK: - MKMapViewDelegate

extension ShopDetailViewController: MKMapViewDelegate {
    
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
