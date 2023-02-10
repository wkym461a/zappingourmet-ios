//
//  ViewController.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/10.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupUI() {
        self.label.text = "Hello, Zappingourmet!"
        self.label.textColor = .orange
    }
    
    private func updateUI() {
    }
    
    // MARK: - Action

}

