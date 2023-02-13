//
//  PickerInputControl.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/13.
//

import UIKit

final class PickerInputControl: UIControl {
    
    // MARK: - Property
    
    private var picker = UIPickerView()
    weak var dataSource: UIPickerViewDataSource? {
        get {
            return self.picker.dataSource
        }
        
        set {
            self.picker.dataSource = newValue
        }
    }
    weak var delegate: UIPickerViewDelegate? {
        get {
            return self.picker.delegate
        }
        
        set {
            self.picker.delegate = newValue
        }
    }
    
    override var inputView: UIView? {
        return self.picker
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = self.isSelected
                ? UIColor.systemBlue.cgColor
                : UIColor.systemGray.cgColor
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
    
    func getPickerSelectedRow(inComponent: Int) -> Int {
        return self.picker.selectedRow(inComponent: inComponent)
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
}
