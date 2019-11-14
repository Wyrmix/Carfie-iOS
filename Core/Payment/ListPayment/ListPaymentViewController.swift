//
//  ListPaymentViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class ListPaymentViewController: UIViewController {
    static func viewController(for theme: AppTheme) -> ListPaymentViewController {
        let interactor = ListPaymentInteractor(theme: theme)
        let viewController = ListPaymentViewController(theme: theme, interactor: interactor)
        interactor.viewController = viewController
        interactor.getPaymentMethods()
        return viewController
    }
    
    private let theme: AppTheme
    private let interactor: ListPaymentInteractor
    
    // MARK: UIComponents
    
    private let paymentTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView() // prevents extra empty rows from showing
        return tableView
    }()
    
    private let addPaymentButton: CarfieButton = {
        let button = CarfieButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Payment", for: .normal)
        return button
    }()
    
    private var paymentItems: [PaymentTableViewCellViewModel] = []
    
    // MARK: Inits
    
    init(theme: AppTheme, interactor: ListPaymentInteractor) {
        self.theme = theme
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
        
        view.addSubview(paymentTableView)
        paymentTableView.register(PaymentTableViewCell.self, forCellReuseIdentifier: PaymentTableViewCell.reuseIdentifier)
        paymentTableView.separatorColor = .carfieMidGray
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        
        view.addSubview(addPaymentButton)
        addPaymentButton.addTarget(self, action: #selector(addPaymentMethodTouchUpInside(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            paymentTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            paymentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addPaymentButton.topAnchor.constraint(equalTo: paymentTableView.bottomAnchor, constant: 24),
            addPaymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addPaymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addPaymentButton.heightAnchor.constraint(equalToConstant: 44),
            addPaymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: iOS Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    // MARK: Selectors
    
    @objc private func addPaymentMethodTouchUpInside(_ sender: Any?) {
        interactor.addPaymentMethod()
    }
}

extension ListPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func presentPaymentItems(_ paymentItems: [PaymentTableViewCellViewModel]) {
        self.paymentItems = paymentItems
        paymentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.reuseIdentifier, for: indexPath) as? PaymentTableViewCell else {
            fatalError("Could not dequeue cell of type PaymentTableViewCell")
        }
        
        cell.configure(with: paymentItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, view, handler) in
            self.interactor.askToDeletePaymentMethod(indexPath: indexPath)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
