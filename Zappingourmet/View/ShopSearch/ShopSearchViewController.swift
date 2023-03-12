//
//  ShopSearchViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

struct ShopSearchViewControllerParams {}

protocol ShopSearchViewable: AnyObject {
    
    func updateUI()
    func openSettings()
    
}

final class ShopSearchViewController: UIViewController, ViewControllerMakable {
    
    typealias Params = ShopSearchViewControllerParams
    
    // MARK: - Outlet
    
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var creditButton: UIButton!
    @IBOutlet private weak var subtitleAndCreditBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var mapView: ShopSearchMapView!
    @IBOutlet private weak var centeringCurrentLocationButton: UIButton!
    
    @IBOutlet private weak var rangePickerControl: PickerInputControl!
    @IBOutlet private weak var rangeValueLabel: UILabel!
    
    @IBOutlet private weak var genrePickerControl: PickerInputControl!
    @IBOutlet private weak var genreValueLabel: UILabel!
    
    @IBOutlet private weak var searchButton: UIButton!
    
    // MARK: - Property
    
    internal var params: ShopSearchViewControllerParams?
    
    private var presenter: ShopSearchPresentable?
    
    private var subtitleBottomAndCreditTopConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopSearchPresenter(self)
        self.presenter?.fetchHotPepperGenres()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.authorizationStatusActions { _ in
            self.view.endEditing(true)
            self.presenter?.startUpdatingLocation()
            
        } unauthorized: { _ in
            self.openSettings()
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        self.navigationController?.navigationBar.tintColor = Constant.Color.baseOrange
        
        self.layoutSubtitleAndCredit()
        
        let gesture: UITapGestureRecognizer = .init(
            target: self,
            action: #selector(self.dismissPickerInput)
        )
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
        let rangeValue = self.presenter?.getHotPepperGourmetSearchRange(index: self.rangePickerControl.picker.selectedRow(inComponent: 0))?.rangeValue ?? 0
        self.mapView.rangeValue = rangeValue
        
        self.centeringCurrentLocationButton.backgroundColor = Constant.Color.baseOrange
        self.centeringCurrentLocationButton.layer.cornerRadius = 22
        self.centeringCurrentLocationButton.layer.shadowOffset = .init(width: 0.0, height: 2.0)
        self.centeringCurrentLocationButton.layer.shadowColor = UIColor.black.cgColor
        self.centeringCurrentLocationButton.layer.shadowOpacity = 0.6
        self.centeringCurrentLocationButton.layer.shadowRadius = 4
        
        self.rangePickerControl.picker.tag = 1
        self.rangePickerControl.selectedColor = Constant.Color.baseOrange
        self.rangePickerControl.layer.cornerRadius = 8
        self.rangePickerControl.layer.borderWidth = 2
        self.rangePickerControl.picker.dataSource = self
        self.rangePickerControl.picker.delegate = self
        
        self.genrePickerControl.picker.tag = 2
        self.genrePickerControl.selectedColor = Constant.Color.baseOrange
        self.genrePickerControl.layer.cornerRadius = 8
        self.genrePickerControl.layer.borderWidth = 2
        self.genrePickerControl.picker.dataSource = self
        self.genrePickerControl.picker.delegate = self
        
        self.searchButton.layer.cornerRadius = 8
        self.searchButton.backgroundColor = Constant.Color.baseOrange
    }
    
    // Changing AutoLayout when Screen width is small.
    private func layoutSubtitleAndCredit() {
        let componentsWidth: CGFloat = self.subtitleLabel.frame.width + self.creditButton.frame.width + 16 * 2
        let isOverlapped = componentsWidth > UIScreen.main.bounds.width
        
        if isOverlapped {
            guard let subtitleLabel = self.subtitleLabel else {
                return
            }
            
            NSLayoutConstraint.deactivate([self.subtitleAndCreditBottomConstraint])
            
            self.subtitleBottomAndCreditTopConstraint = .init(
                item: subtitleLabel,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self.creditButton,
                attribute: .top,
                multiplier: 1.0,
                constant: -4
            )
            if let constraint = self.subtitleBottomAndCreditTopConstraint {
                NSLayoutConstraint.activate([constraint])
            }
            
        } else {
            if let constraint = self.subtitleBottomAndCreditTopConstraint {
                NSLayoutConstraint.deactivate([constraint])
            }
            
            NSLayoutConstraint.activate([self.subtitleAndCreditBottomConstraint])
        }
    }
    
    private func goAlertWhenFailedToGetLocation() {
        let alert = UIAlertController.messageAlert(
            title: "位置情報の取得に失敗",
            message: "位置情報サービスを有効化するか、位置情報が取得できる場所で使用してください。"
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action
    
    @objc private func dismissPickerInput() {
        self.view.endEditing(true)
    }
    
    @IBAction private func openCreditURL(_ sender: UIButton) {
        self.openURLSafely(Constant.creditURL)
    }
    
    @IBAction private func searchShops(_ sender: UIButton) {
        self.presenter?.authorizationStatusActions { _ in
            guard
                let presenter = self.presenter,
                let currentLocation = presenter.getCurrentLocation()
            
            else {
                self.goAlertWhenFailedToGetLocation()
                return
            }
            
            presenter.stopUpdatingLocation()
            
            let shopListParams = ShopListViewControllerParams(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude,
                searchRange: presenter.getHotPepperGourmetSearchRange(index: self.rangePickerControl.picker.selectedRow(inComponent: 0)),
                genre: presenter.getHotPepperGenre(index: self.genrePickerControl.picker.selectedRow(inComponent: 0))
            )
            let shopList = ShopListViewController.makeViewController(params: shopListParams)
            self.navigationController?.pushViewController(shopList, animated: true)
            
        } unauthorized: { _ in
            self.openSettings()
        }
    }
    
    @IBAction private func centeringCurrentLocation(_ sender: UIButton) {
        self.presenter?.authorizedFilter { _ in
            self.mapView.refreshVisibleRect(animated: true)
        }
    }
    
}

// MARK: - ShopSearchViewable

extension ShopSearchViewController: ShopSearchViewable {
    
    func updateUI() {
        let selectedRangeIndex = self.rangePickerControl.picker.selectedRow(inComponent: 0)
        if let count = self.presenter?.getHotPepperGourmetSearchRangesCount(), count > 0 {
            self.rangeValueLabel.text = self.presenter?.getHotPepperGourmetSearchRange(index: selectedRangeIndex)?.name
        }
        
        let selectedGenreIndex = self.genrePickerControl.picker.selectedRow(inComponent: 0)
        if let count = self.presenter?.getHotPepperGenresCount(), count > 0 {
            self.genreValueLabel.text = self.presenter?.getHotPepperGenre(index: selectedGenreIndex).name
        }
    }
    
    func openSettings() {
        let alert = UIAlertController.confirmActionAlert(
            title: "位置情報の設定",
            message: "周辺のレストランを検索するためには、位置情報の使用を許可してください。",
            confirmTitle: "設定を開く"
            
        ) { _ in
            self.openURLSafely(
                URL(string: UIApplication.openSettingsURLString),
                failed: .messageAlert(title: "設定が開けません", message: "")
            )
        }

        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UIPickerViewDataSource

extension ShopSearchViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.presenter?.getHotPepperGourmetSearchRangesCount() ?? 0
        
        case 2:
            return self.presenter?.getHotPepperGenresCount() ?? 0
        
        default:
            return 0
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return self.presenter?.getHotPepperGourmetSearchRange(index: row)?.name
            
        case 2:
            return self.presenter?.getHotPepperGenre(index: row).name
            
        default:
            return nil
        }
        
    }
    
}

// MARK: - UIPickerViewDelegate

extension ShopSearchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            self.updateUI()
            
            self.presenter?.authorizedFilter { _ in
                let rangeValue = self.presenter?.getHotPepperGourmetSearchRange(index: self.rangePickerControl.picker.selectedRow(inComponent: 0))?.rangeValue ?? 0
                self.mapView.updateUI(rangeValue: rangeValue)
                
                self.mapView.refreshVisibleRect(animated: true)
            }
            return
            
        case 2:
            self.updateUI()
            return
            
        default:
            return
        }
        
    }
    
}
