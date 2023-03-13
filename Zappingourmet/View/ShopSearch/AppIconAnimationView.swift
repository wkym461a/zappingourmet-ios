//
//  AppIconAnimationView.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/03/13.
//

import UIKit
import SwiftyGif

final class AppIconAnimationView: UIView {
    
    // MARK: - Outlet
    
    // MARK: - Property
    
    private(set) var imageView = UIImageView()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Public
    
    func startAnimation() {
        self.imageView.startAnimatingGif()
    }
    
    // MARK: - Private

    private func commonInit() {
        self.backgroundColor = .init(red: 225 / 255, green: 126 / 255, blue: 27 / 255, alpha: 1)
        
        self.imageView.image = .init(named: "AppIcon-animation-cover.png")
        self.addSubview(self.imageView)
        
        do {
            let gifImage = try UIImage(gifName: "AppIcon-animation.gif")
            self.imageView.setGifImage(gifImage, loopCount: 1)
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            self.imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            self.imageView.widthAnchor.constraint(equalToConstant: 512).isActive = true
            self.imageView.heightAnchor.constraint(equalToConstant: 512).isActive = true
            
            self.imageView.delegate = self
            
        } catch {
            fatalError("AppIconAnimationView Error: \(error)")
        }
    }
    
}

// MARK: - SwiftyGifDelegate

extension AppIconAnimationView: SwiftyGifDelegate {
    
    func gifDidStop(sender: UIImageView) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { () in
                self.alpha = 0
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
    
}
