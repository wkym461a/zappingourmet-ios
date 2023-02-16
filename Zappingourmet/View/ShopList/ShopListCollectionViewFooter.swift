//
//  ShopListCollectionViewFooter.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/16.
//

import UIKit

final class ShopListCollectionViewFooter: UICollectionReusableView {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var resultsAvailableLabel: UILabel!
    
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    func updateUI(isLoading: Bool, resultsAvailable: Int) {
        self.activityIndicatorView.isHidden = !isLoading
        self.resultsAvailableLabel.isHidden = isLoading
        
        self.resultsAvailableLabel.text = "以上 \(resultsAvailable)件"
    }
    
    // MARK: - Private
    
    private func setupUI() {
    }
    
    // MARK: - Action

}
