//
//  ShopSearchViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import UIKit

protocol ShopSearchViewable: AnyObject {
    
    func updateUI()
    
}

final class ShopSearchViewController: UIViewController, ViewControllerMakable {
    
    struct Params {}
    
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
    
    internal var params: Params?
    
    private var presenter: ShopSearchPresentable?
    
    private var subtitleBottomAndCreditTopConstraint: NSLayoutConstraint?
    
    private var selectedSearchRange: HotPepperGourmetSearchRange? {
        return self.presenter?.getHotPepperGourmetSearchRange(index: self.rangePickerControl.picker.selectedRow(inComponent: 0))
    }
    private var selectedGenre: Genre? {
        return self.presenter?.getHotPepperGenre(index: self.genrePickerControl.picker.selectedRow(inComponent: 0))
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ShopSearchPresenter(self)
        self.presenter?.startUpdatingLocation()
        self.presenter?.fetchHotPepperGenres()
        
        self.setupUI()
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
        
        self.mapView.rangeValue = self.selectedSearchRange?.rangeValue ?? 0
        
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
    
    private func openSettings() {
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
    
    // MARK: - Action
    
    @objc private func dismissPickerInput() {
        self.view.endEditing(true)
    }
    
    @IBAction private func openCreditURL(_ sender: UIButton) {
        self.openURLSafely(Constant.creditURL)
    }
    
    @IBAction private func searchShops(_ sender: UIButton) {
        self.presenter?.authorizationStatusActions { _ in
            guard let currentLocation = self.presenter?.getCurrentLocation() else {
                let alert = UIAlertController.messageAlert(
                    title: "位置情報の取得に失敗",
                    message: "位置情報サービスを有効化するか、位置情報が取得できる場所で使用してください。"
                )
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let shopListParams = ShopListViewController.Params(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude,
                searchRange: self.selectedSearchRange,
                genre: self.selectedGenre
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
        self.rangeValueLabel.text = self.selectedSearchRange?.name
        self.genreValueLabel.text = self.selectedGenre?.name
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
            return self.presenter?.getHotPepperGenre(index: row)?.name
            
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
                self.mapView.updateUI(rangeValue: self.selectedSearchRange?.rangeValue ?? 0)
                
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
