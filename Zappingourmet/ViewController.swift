//
//  ViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/10.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Property
    
    private var labelText: String = "Hello, Zappingourmet!"
    private var cancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.updateUI()
        
        self.cancellable = HotPepperAPI.shared.request(
            target: HotPepperGourmetSearch(
                lat: 35.17454481366307,
                lng: 136.91228418325178,
                start: 501,
                count: 100
            )
        ).sink { completion in
            print(completion)

        } receiveValue: { response in
            let results = response.results
            if let error = results.error {
                error.forEach {
                    print("HOT PEPPER API Error: \($0.message) (code: \($0.code)")
                }
                return
            }
            
            guard let hpShops = results.shop else {
                fatalError("Unexpect Error: Unknown Response \(results)")
            }
            let shops = hpShops.map { Shop.fromHotPepperShop($0) }
            
            let shop = shops[0]
            self.labelText = "\(shop.name)\n\(shop.address)"
            self.updateUI()
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        print(#function)
        self.label.textColor = .orange
    }
    
    private func updateUI() {
        print(#function)
        self.label.text = self.labelText
    }
    
    // MARK: - Action

}

