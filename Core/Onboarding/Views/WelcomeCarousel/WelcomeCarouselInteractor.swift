//
//  WelcomeInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/22/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class WelcomeCarouselInteractor {
    weak var viewController: WelcomeCarouselViewController?
    
    private let theme: AppTheme
    
    init(theme: AppTheme) {
        self.theme = theme
    }
    
    func getCarouselItemsData() {
        switch theme {
        case .driver:
            viewController?.presentCarouselItems(WelcomeCarouselData.driverItems)
        case .rider:
            viewController?.presentCarouselItems(WelcomeCarouselData.driverItems)
        }
    }
}

struct WelcomeCarouselData {
    static let driverItems: [WelcomeCarouselCellViewState] = [
        WelcomeCarouselCellViewState(
            theme: .driver,
            topLabelText: nil,
            image: nil,
            boldText: "Drive for Carfie.\nGet Paid.\nEarn rewards.",
            bottomLabelText: "The only ridesharing app for events and conventions",
            showActionButton: false,
            actionButtonLink: nil
        ),
        WelcomeCarouselCellViewState(
            theme: .driver,
            topLabelText: nil,
            image: UIImage(named: "Jingleball"),
            boldText: "Complete 2 rides to and from Jingle ball for a $1000 sign up bonus",
            bottomLabelText: nil,
            showActionButton: true,
            actionButtonLink: nil
        ),
        WelcomeCarouselCellViewState(
            theme: .driver,
            topLabelText: nil,
            image: UIImage(named: "WalletBonus"),
            boldText: "Complete 150 rides in 90 days for a $500 bonus",
            bottomLabelText: nil,
            showActionButton: true,
            actionButtonLink: nil
        ),
    ]
}
