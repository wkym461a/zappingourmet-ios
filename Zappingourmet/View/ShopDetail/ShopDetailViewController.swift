//
//  ShopDetailViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

protocol ShopDetailViewable: AnyObject {
    
    func updateUI()
    
}

final class ShopDetailViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var nameLabel: UILabel!
    
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
        self.nameLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    // MARK: - Action

}

// MARK: - ShopDetailViewable

extension ShopDetailViewController: ShopDetailViewable {
    
    func updateUI() {
        guard let shop = self.presenter?.getItem() else {
            return
        }
        self.nameLabel.text = shop.name
    }
    
}
