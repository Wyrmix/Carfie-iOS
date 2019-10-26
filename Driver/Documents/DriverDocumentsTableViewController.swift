//
//  DocumentsTableViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DriverDocumentsTableViewController: UITableViewController {
    static func viewController() -> DriverDocumentsTableViewController {
        let presenter = DriverDocumentsPresenter()
        let interactor = DriverDocumentsInteractor(presenter: presenter)
        let viewController = DriverDocumentsTableViewController(interactor: interactor)
        presenter.viewController = viewController
        interactor.start()
        return viewController
    }
    
    private let reuseIdentifier = "DriverDocumentCell"
    
    private let interactor: DriverDocumentsInteractor
    
    private var documentCellViewData = [DriverDocumentCellViewModel]()
    
    init(interactor: DriverDocumentsInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = "Documents"
        
        tableView.register(DriverDocumentsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

// MARK: - UITableView DataSource and Delegate
extension DriverDocumentsTableViewController {
    func presentDocument(viewModels: [DriverDocumentCellViewModel]) {
        documentCellViewData = viewModels
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentCellViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DriverDocumentsTableViewCell else {
            fatalError("Unable to dequeue cell with identifier: \(reuseIdentifier)")
        }
        
        cell.configure(with: documentCellViewData[indexPath.row])
        return cell
    }
}
