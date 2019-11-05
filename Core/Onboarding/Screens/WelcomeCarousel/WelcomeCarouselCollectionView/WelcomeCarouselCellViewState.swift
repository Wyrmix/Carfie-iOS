//
//  WelcomeCarouselCellViewState.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/23/19.
//

import UIKit

/// Cell type for the welcome carousel. Tells the collection view which class of cell to dequeue.
enum WelcomeCellType {
    
    /// A  CollectionViewCell with text, an image or animation, and an action button.
    case image
    
    /// A  CollectionViewCell with 2 text labels in large, bold font.
    case text
}

struct WelcomeCarouselCellViewState: Equatable {
    let cellType: WelcomeCellType
    let topLabelText: String?
    let image: UIImage?
    let animationName: String?
    let boldText: String
    let bottomLabelText: String?
    let showActionButton: Bool
    let actionButtonLink: String?
    
    init(cellType: WelcomeCellType,
         topLabelText: String? = nil,
         image: UIImage? = nil,
         animationName: String? = nil,
         boldText: String,
         bottomLabelText: String? = nil,
         actionButtonLink: String? = nil
    ) {
        assert(image == nil  || animationName == nil, "A WelcomeCell cannot display both an animation and an image.")
        
        self.cellType = cellType
        self.topLabelText = topLabelText
        self.image = image
        self.animationName = animationName
        self.boldText = boldText
        self.bottomLabelText = bottomLabelText
        self.showActionButton = actionButtonLink == nil ? false : true
        self.actionButtonLink = actionButtonLink
    }
}
