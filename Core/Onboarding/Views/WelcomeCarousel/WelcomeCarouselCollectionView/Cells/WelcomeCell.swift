//
//  WelcomeCell.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol WelcomeCell: class {
    func configure(with viewState: WelcomeCarouselCellViewState)
}
