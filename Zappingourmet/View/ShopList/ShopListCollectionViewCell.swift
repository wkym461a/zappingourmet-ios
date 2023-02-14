//
//  ShopListCollectionViewCell.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import UIKit

final class ShopListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var shopImageView: ShopImageView!
    @IBOutlet private weak var catchLabel: UILabel!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var accessLabel: UILabel!
    
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    func updateUI(shop: Shop) {
        self.shopImageView.image = UIImage(data: .fromURL(shop.photoURL))
        self.catchLabel.text = shop.`catch`
        
        self.nameLabel.text = shop.name
        self.accessLabel.text = shop.access
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .init(width: 4, height: 4)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
    }
    
    // MARK: - Action

}
