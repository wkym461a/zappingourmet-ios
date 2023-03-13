//
//  ShopDetailViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

protocol ShopDetailViewable: AnyObject {
    
    func updateUI(shop: Shop)
    
}

final class ShopDetailViewController: UIViewController, ViewControllerMakable {
    
    struct Params {
        let item: Shop
    }
    
    // MARK: - Outlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
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
    
    internal var params: Params?
    
    private var presenter: ShopDetailPresentable?
    
    private var headerImageViewDefaultHeight: CGFloat = 0
    
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
        self.scrollView.delegate = self
        
        self.headerImageViewDefaultHeight = self.headerImageView.frame.height
        
        self.tagCollectionView.dataSource = self
        self.tagCollectionView.delegate = self
        self.tagCollectionView.register(
            UINib(nibName: "ShopDetailTagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "tagCell"
        )
        self.tagCollectionView.collectionViewLayout = ShopDetailTagCollectionViewFlowLayout.default
    }
    
    // MARK: - Action
    
    @IBAction private func openShopURL(_ sender: Any) {
        self.openURLSafely(
            self.presenter?.getItem().url,
            failed: .messageAlert(title: "店舗URLが開けません", message: "")
        )
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

// MARK: - UIScrollViewDelegate

extension ShopDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y >= 0.0 {
            self.headerImageView.layer.transform = CATransform3DIdentity
            return
        }
        
        var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset.y / 2, 0)
        let scale = 1 + (-offset.y / self.headerImageViewDefaultHeight)
        transform = CATransform3DScale(transform, scale, scale, 1)
        self.headerImageView.layer.transform = transform
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
