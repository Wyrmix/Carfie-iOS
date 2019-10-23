//
//  WelcomeInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/22/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol WelcomeCarouselInteractor {
    var viewController: WelcomeCarouselViewController? { get set }
    func getCarouselItemsData()
}

class DriverWelcomeCarouselInteractor: WelcomeCarouselInteractor {
    weak var viewController: WelcomeCarouselViewController?
    
    func getCarouselItemsData() {
        viewController?.presentCarouselItems(WelcomeCarouselData.driverItems)
    }
}

struct WelcomeCarouselData {
    static let driverItems: [WelcomeCarouselCellViewState] = [
        WelcomeCarouselCellViewState(
            topLabelText: nil,
            image: nil,
            boldText: "Drive for Carfie.\nGet Paid.\nEarn rewards.",
            bottomLabelText: "Complete 2 rides to and from Jingle ball for a $1000 sign up bonus",
            showActionButton: false,
            actionButtonLink: nil
        ),
        WelcomeCarouselCellViewState(
            topLabelText: nil,
            image: UIImage(named: "Jingleball"),
            boldText: "Complete 2 rides to and from Jingle ball for a $1000 sign up bonus",
            bottomLabelText: nil,
            showActionButton: true,
            actionButtonLink: nil
        ),
        WelcomeCarouselCellViewState(
            topLabelText: nil,
            image: UIImage(named: "WalletBonus"),
            boldText: "Complete 150 rides in 90 days for a $500 bonus",
            bottomLabelText: nil,
            showActionButton: true,
            actionButtonLink: nil
        ),
    ]
}
