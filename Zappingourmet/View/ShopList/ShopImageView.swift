//
//  ShopImageView.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import UIKit

final class ShopImageView: UIImageView {
    
    // MARK: - Property

    private var gradientLayer: CAGradientLayer {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0).cgColor,
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1).cgColor,
        ]

        gradientLayer.startPoint = .init(x: 0.5, y: 0.7)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)

        return gradientLayer
    }
    
    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.frame = self.bounds }
    }
    
    // MARK: - Public
    
    // MARK: - Private

    private func setupUI() {
        self.layer.addSublayer(self.gradientLayer)
    }

}
