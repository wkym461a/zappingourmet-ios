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
    
    @IBOutlet private weak var accessTitleLabel: UILabel!
    @IBOutlet private weak var accessLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    
    // MARK: - Property
    
    private var presenter: ShopDetailPresentable?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopDetailPresenter(self)
        
        self.setupUI()
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
        
        self.accessTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        self.accessLabel.font = .systemFont(ofSize: 14)
        self.accessLabel.numberOfLines = -1
        
        self.mapView.layer.cornerRadius = 8
        self.mapView.clipsToBounds = true
        
        self.addressLabel.textColor = .darkGray
        self.addressLabel.font = .systemFont(ofSize: 12)
        self.addressLabel.numberOfLines = -1
    }
    
    // MARK: - Action

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
        
        self.accessTitleLabel.text = "アクセス"
        self.accessLabel.text = shop.access
        
        self.addressLabel.text = shop.address
    }
    
}
