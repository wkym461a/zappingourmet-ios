//
//  ViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/10.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Property
    
    private var labelText: String = "Hello, Zappingourmet!"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.updateUI()
        
        let provider = MoyaProvider<HotPepperAPI>()
        let homeLatitude: Double = 35.17454481366307
        let homeLongitude: Double = 136.91228418325178
        provider.request(.gourmetSearch(latitude: homeLatitude, longitude: homeLongitude, range: .oneThousand)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                do {
                    let json = try response.mapJSON()
                    print(json)
                    self.labelText = "Success HotPepperAPI!"
                    self.updateUI()
                    
                } catch {
                    print(error)
                }
                
            case let .failure(moyaError):
                print(moyaError)
            }
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        self.label.textColor = .orange
    }
    
    private func updateUI() {
        self.label.text = self.labelText
    }
    
    // MARK: - Action

}

