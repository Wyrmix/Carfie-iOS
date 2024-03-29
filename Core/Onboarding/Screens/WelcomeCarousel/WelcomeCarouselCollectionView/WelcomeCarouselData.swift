//
//  WelcomeCarouselData.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/23/19.
//

import UIKit

/// Data structures to populate the welcome carousels for both the Driver and Rider apps.
/// TODO: move to a backend service.
struct WelcomeCarouselData {
    
    // MARK: Driver Data
    
    static let driverItems: [WelcomeCarouselCellViewState] = [
        WelcomeCarouselCellViewState(
            cellType: .text,
            boldText: "Drive for Carfie.\nGet Paid.\nEarn rewards.",
            bottomLabelText: "The only ridesharing app for events and conventions"
        ),
        WelcomeCarouselCellViewState(
            cellType: .image,
            image: UIImage(named: "Jingleball"),
            boldText: "Complete 2 rides to and from Jingle ball for a $1000 sign up bonus",
            actionButtonLink: "https://go.carfie.com/signup"
        ),
        WelcomeCarouselCellViewState(
            cellType: .image,
            animationName: "wallet",
            boldText: "Complete 150 rides in 90 days for a $500 bonus",
            actionButtonLink: "https://go.carfie.com/signup"
        ),
    ]
    
    // MARK: Rider Data
    
    static let riderItems: [WelcomeCarouselCellViewState] = [
        WelcomeCarouselCellViewState(
            cellType: .text,
            boldText: "Ride with Carfie.\nEarn rewards.\nSave Money.",
            bottomLabelText: "The only ridesharing app for events and conventions"
        ),
        WelcomeCarouselCellViewState(
            cellType: .image,
            topLabelText: "To celebrate our official partnership with iHeart Radio Jingleball 2019 we are offering our riders",
            image: UIImage(named: "Jingleball"),
            boldText: "10% off your first ride and a chance to win $1000",
            actionButtonLink: "https://go.carfie.com/signup"
        ),
        WelcomeCarouselCellViewState(            
            cellType: .image,
            topLabelText: "Take a selfie in your Carfie ride post to social media and tag Carfie",
            animationName: "insta-camera",
            boldText: "For a chance to win $1000",
            actionButtonLink: "https://go.carfie.com/signup"
        ),
    ]
}

