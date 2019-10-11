//
//  Router.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation
import UIKit


class Router {
    
    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let user = UIStoryboard(name: "User", bundle: Bundle.main)
    
    /// Configures some stuff that's apparently needed for the app to function.
    static func configure() {
        // I'm not clear on what this function does yet and will likely need some serious architecture changes
        // to address and untangle.
        
        let presenter : PostPresenterInputProtocol&PostPresenterOutputProtocol = Presenter()
        let interactor : PostInteractorInputProtocol&PostInteractorOutputProtocol = Interactor()
        let webService : PostWebServiceProtocol = Webservice()
      
        if let view : (PostViewProtocol & UIViewController) = user.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchViewController) as? ViewController {
            presenter.controller = view
            view.presenter = presenter
            presenterObject = view.presenter
        }
        
        webService.interactor = interactor
        interactor.webService = webService
        interactor.presenter = presenter
        presenter.interactor = interactor
    }
}
