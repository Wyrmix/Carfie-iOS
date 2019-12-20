//
//  CarfieTextField.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/27/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import CoreGraphics
import UIKit

protocol CarfieTextInputViewDelegate: class {
    func textInputViewDidBeginEditing(_ textInputView: CarfieTextInputView)
    func textInputViewDidEndEditing(_ textInputView: CarfieTextInputView)
    func textInputViewShouldReturn(_ textInputView: CarfieTextInputView) -> Bool
}

/// A view that encapsulates a title label that is palced above a UITextField.
class CarfieTextInputView: UIView {
    
    weak var delegate: CarfieTextInputViewDelegate?
    
    // MARK: TextField "overrides"
    
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
    
    var autocorrectionType: UITextAutocorrectionType {
        didSet {
            textField.autocorrectionType = autocorrectionType
        }
    }
    
    var text: String? {
        return textField.text
    }
    
    // MARK: Validation
    
    /// Validator for applying business logic to the entered text.
    var validator: Validator?
    
    // MARK: UI Components
    
    /// Text field for user input. This is internal to allow access to callers that need to modify the text field directly.
    let textField: CarfieTextField
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .carfieSmallBody
        label.textColor = .carfieDarkGray
        return label
    }()
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .carfieMicrocopy
        label.textColor = .carfieDarkGray
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: Inits
    
    init(title: String? = nil,
         placeholder: String? = nil,
         isSecureTextEntry: Bool = false,
         keyboardType: UIKeyboardType = .default,
         autocorrectionType: UITextAutocorrectionType = .default,
         validator: Validator? = nil)
    {
        self.title = title
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.autocorrectionType = autocorrectionType
        self.validator = validator
        self.textField = CarfieTextField()
        
        super.init(frame: .zero)
        
        self.textField.delegate = self
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        addSubview(titleLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecureTextEntry
        textField.keyboardType = keyboardType
        textField.autocorrectionType = autocorrectionType
        addSubview(textField)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            errorMessageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: Utility Functions
    
    /// Validate the text entered into the field. Uses a preset Validator to apply business rules.
    /// - returns .success if the text matches the business rules or if there is no validator to use.
    func validate() -> Result<String> {
        guard let validator = validator else {
            return .success(textField.text ?? "")
        }
        
        do {
            let _ = try validator.validate(textField.text).resolve()
            animateErrorLabel()
            errorMessageLabel.text = nil
        } catch let error as ValidationError {
            animateErrorLabel()
            errorMessageLabel.text = error.errorMessage
        } catch {}
        
        return validator.validate(textField.text)
    }
    
    private func animateErrorLabel() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.25
        animation.type = .reveal
        animation.subtype = .fromBottom
        errorMessageLabel.layer.add(animation, forKey: CATransitionType.push.rawValue)
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

// MARK: - UITextFieldDelegate
extension CarfieTextInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textInputViewDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textInputViewDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else { return true }
        return delegate.textInputViewShouldReturn(self)
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
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.carfieLightGray,
            NSAttributedString.Key.font: UIFont.carfieSmallBody,
        ]

        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        
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
