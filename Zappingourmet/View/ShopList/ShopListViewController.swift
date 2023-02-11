//
//  ShopListViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import UIKit

protocol ShopListViewable: AnyObject {
    
    func updateUI()
    
}

final class ShopListViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Property
    
    private var presenter: ShopListPresentable?
    
    private struct CollectionViewConstants {

        static let numberOfCellColumns: Int = 1
        static let interCellColumnSpacing: CGFloat = 8
        static let interCellRowSpacing: CGFloat = 8
        static let contentsEdgeInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

    }
    
    private var collectionViewCellWidth: CGFloat {
        let contentsLeftRightMargin = CollectionViewConstants.contentsEdgeInsets.left + CollectionViewConstants.contentsEdgeInsets.right
        let numberOfCellColumns = max(CollectionViewConstants.numberOfCellColumns, 1)
        let interCellsColumnMargin = (numberOfCellColumns > 1) ? CollectionViewConstants.interCellColumnSpacing * CGFloat(numberOfCellColumns - 1) : 0
        let horizontalMargin = contentsLeftRightMargin + interCellsColumnMargin
        
        return (self.collectionView.frame.width - horizontalMargin) / CGFloat(numberOfCellColumns)
    }
    
    private var collectionViewCellHeight: CGFloat {
        return self.collectionViewCellWidth
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopListPresenter(self)
        self.presenter?.fetchShops()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(
            UINib(nibName: "ShopListCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "shopCell"
        )
        self.collectionView.backgroundColor = .darkGray
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .zero
    }
    
    // MARK: - Action

}

// MARK: - ShopListViewable

extension ShopListViewController: ShopListViewable {
    
    func updateUI() {
        self.collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource

extension ShopListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter?.getShopsCount() ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let shop = self.presenter?.getShop(index: indexPath.row),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as? ShopListCollectionViewCell
                
        else {
            return UICollectionViewCell()
        }
        
        cell.updateUI(shop: shop)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension ShopListViewController: UICollectionViewDelegate {
    
    private func nextFetchThreshold(_ scrollView: UIScrollView) -> CGFloat {
        return scrollView.frame.height * 2.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        
        if distanceToBottom < self.nextFetchThreshold(scrollView) {
            self.presenter?.fetchShops()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShopListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(
            width: self.collectionViewCellWidth,
            height: self.collectionViewCellHeight
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return CollectionViewConstants.contentsEdgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewConstants.interCellRowSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewConstants.interCellColumnSpacing
    }
    
}
