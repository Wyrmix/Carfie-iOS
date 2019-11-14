//
//  AddPaymentViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/6/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Stripe
import UIKit

class AddPaymentViewController: UIViewController {
    static func viewController(for theme: AppTheme, and delegate: AddCardDelegate? = nil) -> AddPaymentViewController {
        let interactor = AddPaymentInteractor(theme: theme)
        let viewController = AddPaymentViewController(interactor: interactor)
        interactor.viewController = viewController
        interactor.delegate = delegate
        return viewController
    }
    
    private let interactor: AddPaymentInteractor
    
    // MARK: UI Components
    
    private let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navigationItem = UINavigationItem()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouchUpInside(_:)))
        navigationItem.rightBarButtonItem = cancelButton
        navigationBar.items = [navigationItem]
        return navigationBar
    }()
    
    private let creditCardEntryField: STPPaymentCardTextField = {
        let field = STPPaymentCardTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let addPaymentButton: AnimatedCarfieButton = {
        let button = AnimatedCarfieButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPaymentButtonTouchUpInside(_:)), for: .touchUpInside)
        button.setTitle("Add Payment", for: .normal)
        return button
    }()
    
    // MARK: Inits
    
    init(interactor: AddPaymentInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(navigationBar)
        view.addSubview(creditCardEntryField)
        view.addSubview(addPaymentButton)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            creditCardEntryField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 24),
            creditCardEntryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            creditCardEntryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addPaymentButton.topAnchor.constraint(equalTo: creditCardEntryField.bottomAnchor, constant: 16),
            addPaymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addPaymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addPaymentButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: Selectors
    
    @objc private func addPaymentButtonTouchUpInside(_ sender: Any?) {
        interactor.addPayment(creditCardEntryField.cardParams)
    }
    
    @objc private func cancelButtonTouchUpInside(_ sender: Any?) {
        interactor.dismiss()
    }
    
    // MARK: Presenters
    
    func animateSaveButton(_ animate: Bool) {
        if animate {
            addPaymentButton.startAnimating()
        } else {
            addPaymentButton.stopAnimating()
        }
    }
}
