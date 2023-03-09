//
//  ShopDetailViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit
import MapKit

struct ShopDetailViewControllerParams {
    
    let item: Shop
    
}

protocol ShopDetailViewable: AnyObject {
    
    func updateUI()
    
}

final class ShopDetailViewController: UIViewController, ViewControllerMakable {
    
    typealias Params = ShopDetailViewControllerParams
    
    
    // MARK: - Outlet
    
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var openLabel: UILabel!
    
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var tagCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var detailMemoLabel: UILabel!
    @IBOutlet private weak var shopURLButton: UIButton!
    
    @IBOutlet private weak var accessLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    
    // MARK: - Property
    
    internal var params: ShopDetailViewControllerParams?
    
    private var presenter: ShopDetailPresentable?
    
    private var tagCollectionViewFlowLayout: ShopDetailTagCollectionViewFlowLayout {
        let layout = ShopDetailTagCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = .zero
        return layout
    }
    
    private var mapViewOverlaysEdgePadding: UIEdgeInsets {
        return .init(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopDetailPresenter(self, item: self.params?.item)
        self.params = nil
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tagCollectionViewHeightConstraint.constant = self.tagCollectionView.contentSize.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.tagCollectionView.bounds.size.height != self.tagCollectionView.contentSize.height {
            self.tagCollectionViewHeightConstraint.constant = self.tagCollectionView.contentSize.height
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        self.tagCollectionView.dataSource = self
        self.tagCollectionView.delegate = self
        self.tagCollectionView.register(
            UINib(nibName: "ShopDetailTagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "tagCell"
        )
        self.tagCollectionView.collectionViewLayout = self.tagCollectionViewFlowLayout
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.layer.cornerRadius = 8
        self.createMapViewRoute()
    }
    
    private func createMapViewRoute() {
        guard let shop = self.presenter?.getItem() else {
            return
        }
        
        self.mapView.getRoutesFromCurrentLocation(to: shop.coordinate) { routes in
            guard let route = routes.first else {
                return
            }
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            self.mapView.setVisibleOverlays(
                edgePadding: self.mapViewOverlaysEdgePadding,
                animated: false
            )
        }
    }
    
    // MARK: - Action
    
    @IBAction private func openShopURL(_ sender: Any) {
        guard
            let shopURL = self.presenter?.getItem().url,
            UIApplication.shared.canOpenURL(shopURL)
            
        else {
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
        
        self.headerImageView.loadImage(contentOf: shop.photoURL)
        self.nameLabel.text = shop.name
        self.openLabel.text = shop.open
        
        self.detailMemoLabel.text = (shop.detailMemo.count > 0) ? shop.detailMemo : "なし"
        let shopURLString = shop.url.absoluteString
        let attributeShopURLString: NSMutableAttributedString = .init(string: shopURLString)
        attributeShopURLString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: .init(location: 0, length: shopURLString.count)
        )
        self.shopURLButton.setAttributedTitle(attributeShopURLString, for: .normal)
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
