//
//  WelcomeCell.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol WelcomeCellDelegate: class {
    func showDetailWebView(url: String)
}

protocol WelcomeCell: class {
    /*weak*/ var delegate: WelcomeCellDelegate? { get set }
    func configure(with viewState: WelcomeCarouselCellViewState)
}
