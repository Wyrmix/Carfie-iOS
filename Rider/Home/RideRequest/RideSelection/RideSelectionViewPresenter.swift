//
//  RideSelectionViewPresenter.swift
//  Rider
//
//  Created by Christopher Olsen on 11/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class RideSelectionViewPresenter {
    let rideSelectionView: RequestSelectionView
    
    init(rideSelectionView: RequestSelectionView) {
        self.rideSelectionView = rideSelectionView
    }
    
    func present(viewState: RideSelectionViewState) {
        guard let card = viewState.firstCard else {
            rideSelectionView.selectedCard = nil
            rideSelectionView.paymentType = .NONE
            return
        }
        
        let cardEntity = CardEntity(card)
        rideSelectionView.selectedCard = cardEntity
        rideSelectionView.paymentType = .CARD
    }
}
