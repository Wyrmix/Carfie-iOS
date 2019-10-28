//
//  CarfieTextField.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/27/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import CoreGraphics
import UIKit

/// A view that encapsulates a title label that is palced above a UITextField.
class CarfieTextInputView: UIView {
    
    // MARK: Internal Properties
    
    /// The text to be displayed in the UILabel above the text field.
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var isSecureTextEntry: Bool {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    var keyboardType: UIKeyboardType {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    /// Text field for user input. This is internal to allow modification of the placeholder text and
    /// other necessary attributes.
    let textField: CarfieTextField
    
    // MARK: Private Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .carfieSmallBody
        label.textColor = .carfieDarkGray
        return label
    }()
    
    // MARK: Inits
    
    init(title: String? = nil, placeholder: String? = nil, isSecureTextEntry: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.textField = CarfieTextField()
        
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
        textField.keyboardType = keyboardType
        
        addSubview(titleLabel)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: Facade Functions
    
    /// Makes this view's textField the first responder.
    func makeTextFieldFirstResponser() {
        textField.becomeFirstResponder()
    }
    
    /// Resigns this view's textField as first responder.
    func resignTextFieldFirstResponder() {
        textField.resignFirstResponder()
    }
}

/// A Carfie styled inset UITextField with a 1 point border.
class CarfieTextField: UITextField {
    
    // MARK: Inits
    
    init(title: String? = nil) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup

    private func setup() {
        backgroundColor = .white
        font = .carfieSmallBody
        textColor = .carfieDarkGray
        
        layer.borderColor = UIColor.carfieLightGray.cgColor
        layer.borderWidth = 1
    }
    
    // MARK: Overrides
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
