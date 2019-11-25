//
//  RiderHomeViewState.swift
//  Rider
//
//  Created by Christopher Olsen on 11/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct RiderHomeViewState {
    var rideSelection = RideSelectionViewState(firstCard: nil)
}

/// View state for RequestSelectionView.swift
struct RideSelectionViewState {
    /// The first card in the Rider's list of payment options. Hopefully someday a "default" card
    /// selection will be an option.
    let firstCard: CarfieCard?
}
