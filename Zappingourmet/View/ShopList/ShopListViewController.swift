//
//  ShopListViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import UIKit

struct ShopListViewControllerParams {
    
    let latitude: Double
    let longitude: Double
    let searchRange: HotPepperGourmetSearchRange?
    let genre: Genre?
    
}

protocol ShopListViewable: AnyObject {
    
    func updateUI()
    
}

final class ShopListViewController: UIViewController, ViewControllerMakable {
    
    typealias Params = ShopListViewControllerParams
    
    // MARK: - Outlet
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Property
    
    internal static var storyboardName: String = Constant.StoryboardName.ShopList
    internal var params: ShopListViewControllerParams?
    
    private var presenter: ShopListPresentable?
    
    private struct CollectionViewConstants {

        static let numberOfCellColumns: Int = 1
        static let interCellColumnSpacing: CGFloat = 16
        static let interCellRowSpacing: CGFloat = 16
        static let contentsEdgeInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)

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
        
        self.presenter = ShopListPresenter(self, fetchShopsParams: self.getFetchShopsParams())
        self.params = nil
        
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
        var navigationItemTitle = ""
        if let searchRangeName = self.presenter?.getFetchShopsParamSearchRange()?.name {
            navigationItemTitle += "\(searchRangeName)以内の"
        }
        navigationItemTitle += self.presenter?.getFetchShopsParamGenre()?.name ?? "検索結果"
        self.navigationItem.title = navigationItemTitle
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(
            UINib(nibName: "ShopListCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "shopCell"
        )
        self.collectionView.register(
            UINib(nibName: "ShopListCollectionViewFooter", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "shopListFooter"
        )
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .zero
    }
    
    private func getFetchShopsParams() -> ShopListPresenterFetchShopsParams? {
        guard let params = self.params else {
            return nil
        }
        
        return ShopListPresenterFetchShopsParams(
            latitude: params.latitude,
            longitude: params.longitude,
            searchRange: params.searchRange,
            genre: params.genre
        )
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            guard
                let isFetchedAllAvailableShops = self.presenter?.getIsFetchedAllAvailableShops(),
                let availableShopsCount = self.presenter?.getAvailableShopsCount(),
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shopListFooter", for: indexPath) as? ShopListCollectionViewFooter else {
                return UICollectionReusableView()
            }
            
            footer.updateUI(isLoading: !isFetchedAllAvailableShops, resultsAvailable: availableShopsCount)
            
            return footer
            
        default:
            return UICollectionReusableView()
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let shop = self.presenter?.getShop(index: indexPath.row) else {
            return
        }
        
        let shopDetailParams = ShopDetailViewControllerParams(item: shop)
        let shopDetail = ShopDetailViewController.makeViewController(params: shopDetailParams)
        self.navigationController?.pushViewController(shopDetail, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
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
