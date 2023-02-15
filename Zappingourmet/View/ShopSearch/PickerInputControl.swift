//
//  PickerInputControl.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/13.
//

import UIKit

final class PickerInputControl: UIControl {
    
    // MARK: - Property
    
    private(set) var picker = UIPickerView()
    
    override var inputView: UIView? {
        return self.picker
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var isSelected: Bool {
        didSet {
            self.updateUI()
        }
    }
    
    var selectedColor: CGColor = UIColor.systemBlue.cgColor {
        didSet {
            self.updateUI()
        }
    }
    
    var notSelectedColor: CGColor = UIColor.systemGray.cgColor {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    // MARK: - Public
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let value = super.becomeFirstResponder()
        self.isSelected = self.isFirstResponder
        return value
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        let value = super.resignFirstResponder()
        self.isSelected = self.isFirstResponder
        return value
    }
    
    // MARK: - Private
    
    private func setup() {
        self.layer.borderColor = UIColor.systemGray.cgColor
        
        self.addAction(
            .init() { [weak self] _ in
                self?.isSelected.toggle()
                
                if self?.isSelected == true {
                    self?.becomeFirstResponder()
                    
                } else {
                    self?.resignFirstResponder()
                }
            },
            for: .touchUpInside
        )
    }
    
    private func updateUI() {
        self.layer.borderColor = self.isSelected
            ? self.selectedColor
            : self.notSelectedColor
    }
}
