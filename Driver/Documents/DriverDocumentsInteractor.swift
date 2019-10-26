//
//  DriverDocumentsInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class DriverDocumentsInteractor {
    
    let presenter: DriverDocumentsPresenter
    
    private let networkService: NetworkService
    
    private var documents = [DriverDocument]()
    
    init(presenter: DriverDocumentsPresenter, networkService: NetworkService = DefaultNetworkService()) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    func start() {
        getDocuments()
    }
    
    private func getDocuments() {
        // get documents from data service if they exist
        let authorizedRequest = DriverAuthorizedRequest<DriverDocumentList>(request: DriverDocumentsRequest())
        networkService.request(authorizedRequest) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let documentList = try result.resolve()
                self.presenter.presentDocuments(documentList.documents)
            } catch {
                print(error)
                // log error or something
            }
        }
    }
    
    private func sendDocuments() {
        // post documents to service
    }
}
