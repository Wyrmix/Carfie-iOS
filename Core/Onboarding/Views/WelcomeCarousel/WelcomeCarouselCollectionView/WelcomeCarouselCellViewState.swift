//
//  WelcomeCarouselCellViewState.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/23/19.
//

import UIKit

struct WelcomeCarouselCellViewState: Equatable {
    let theme: AppTheme
    let topLabelText: String?
    let image: UIImage?
    let boldText: String
    let bottomLabelText: String?
    let showActionButton: Bool
    let actionButtonLink: String?
}
