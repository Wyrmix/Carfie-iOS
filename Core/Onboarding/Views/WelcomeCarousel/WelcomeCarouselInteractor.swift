//
//  WelcomeInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/22/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class WelcomeCarouselInteractor {
    weak var viewController: WelcomeCarouselViewController?
    
    private let theme: AppTheme
    
    init(theme: AppTheme) {
        self.theme = theme
    }
    
    /// Get data to populate the welcome carousels.
    /// Will trigger a reload of the collection view.
    // TODO: Add a presentation layer
    func getCarouselItemsData() {
        switch theme {
        case .driver:
            viewController?.presentCarouselItems(WelcomeCarouselData.driverItems)
        case .rider:
            viewController?.presentCarouselItems(WelcomeCarouselData.riderItems)
        }
    }
}
