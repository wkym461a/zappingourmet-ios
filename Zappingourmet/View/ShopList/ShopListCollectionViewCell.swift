//
//  ShopListCollectionViewCell.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import UIKit

final class ShopListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var accessLabel: UILabel!
    @IBOutlet private weak var shopImageView: ShopImageView!
    
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    func updateUI(shop: Shop) {
        self.nameLabel.text = shop.name
        self.accessLabel.text = shop.access
        self.shopImageView.image = UIImage(data: .fromURL(shop.photoURL))
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
        
        self.nameLabel.font = .boldSystemFont(ofSize: 22)
        self.nameLabel.textColor = .white
        self.nameLabel.text = "Unknown Shop Name"
        
        self.accessLabel.font = .systemFont(ofSize: 16)
        self.accessLabel.numberOfLines = 2
        
        self.shopImageView.contentMode = .scaleAspectFill
    }
    
    // MARK: - Action

}
