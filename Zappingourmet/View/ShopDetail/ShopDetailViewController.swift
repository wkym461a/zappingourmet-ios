//
//  ShopDetailViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

struct ShopDetailViewControllerParams {
    
    let item: Shop
    
}

protocol ShopDetailViewable: AnyObject {
    
    func updateUI(shop: Shop)
    
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
    @IBOutlet private weak var mapView: ShopDetailMapView!
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopDetailPresenter(self, item: self.params?.item)
        self.params = nil
        
        self.setupUI()
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
    
    func updateUI(shop: Shop) {
        self.headerImageView.loadImage(contentOf: shop.photoURL)
        self.nameLabel.text = shop.name
        self.openLabel.text = shop.open
        
        self.detailMemoLabel.text = (shop.detailMemo.count > 0) ? shop.detailMemo : "なし"
        self.shopURLButton.setAttributedTitle(shop.url.absoluteString.underlined, for: .normal)
        
        self.accessLabel.text = shop.access
        self.mapView.updateUI(destination: shop.coordinate)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
}
