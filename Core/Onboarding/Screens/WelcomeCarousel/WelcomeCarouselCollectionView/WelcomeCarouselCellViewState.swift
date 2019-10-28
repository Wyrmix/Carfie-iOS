//
//  WelcomeCarouselCellViewState.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/23/19.
//

import UIKit

/// Cell type for the welcome carousel. Tells the collection view which class of cell to dequeue.
enum WelcomeCellType {
    
    /// A  CollectionViewCell with text, an image, and an action button.
    case image
    
    /// A  CollectionViewCell with 2 text labels in large, bold font.
    case text
}

struct WelcomeCarouselCellViewState: Equatable {
    let theme: AppTheme
    let cellType: WelcomeCellType
    let topLabelText: String?
    let image: UIImage?
    let boldText: String
    let bottomLabelText: String?
    let showActionButton: Bool
    let actionButtonLink: String?
}
