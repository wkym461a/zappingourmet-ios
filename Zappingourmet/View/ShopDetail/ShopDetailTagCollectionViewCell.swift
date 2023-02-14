//
//  ShopDetailTagCollectionViewCell.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/14.
//

import UIKit

final class ShopDetailTagCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var tagLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tagLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tagLabelTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    func updateUI(tag: String, maxWidth: CGFloat) {
        self.tagLabel.text = tag
        
        let sideMargin = self.tagLabelLeadingConstraint.constant + self.tagLabelTrailingConstraint.constant
        self.tagLabelWidthConstraint.constant = max(0, maxWidth - sideMargin)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.contentView.backgroundColor = Constant.Color.baseOrange
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
        
        self.tagLabel.font = .systemFont(ofSize: 12)
        self.tagLabel.numberOfLines = -1
        self.tagLabel.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Action

}
