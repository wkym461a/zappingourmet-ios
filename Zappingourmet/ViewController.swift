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
    
    @IBAction private func goShopListVC(_ sender: UIButton) {
        let shopListVC = UIStoryboard(name: "ShopList", bundle: nil).instantiateInitialViewController() as! ShopListViewController
        self.present(shopListVC, animated: true, completion: nil)
    }
    
}

