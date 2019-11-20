//
//  rideArrivedView.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import HCSStarRatingView
class rideArrivedView: UIView {
    
    
    //MARK:- view outlets
    @IBOutlet var ratingView: HCSStarRatingView!
    @IBOutlet var viewVisualEffect: UIView!
    @IBOutlet var viewVisualEffectMain: UIVisualEffectView!
    @IBOutlet var viewMessage: UIView!
    
    //MARK:- label outlets
    @IBOutlet var userName: UILabel!
    @IBOutlet var cancelBtn: CarfieButton!
    @IBOutlet var arrivedBtn: CarfieButton!
    @IBOutlet var labelAddress: UILabel!
    @IBOutlet var lablelPickup: UILabel!
    @IBOutlet var labelDestination: UILabel!
    
    @IBOutlet var labelDropValue: UILabel!
    @IBOutlet var labelDrop: UILabel!
    //MARK:- image outlets
    @IBOutlet var imageArrived: UIImageView!
    @IBOutlet var imageFinished: UIImageView!
    @IBOutlet var imagePickup: UIImageView!
    @IBOutlet var userProfile: UIImageView!
    
    //MARK:- progressBar outlets:
    @IBOutlet var progressBarArrivedToPickUp: UIProgressView!
    @IBOutlet var progressBarPickupToFinished: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        self.setCommonFont()
        
        viewMessage.backgroundColor = AppTheme.driver.primaryColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundCorner()
    }
    
    private func localize() {
        arrivedBtn.setTitle("Arrived", for: .normal)
        cancelBtn.setTitle("Cancel", for: .normal)
    }
    
    
    func setCommonFont(){
        setFont(TextField: nil, label: userName, Button: nil, size: nil)
        setFont(TextField: nil, label: lablelPickup, Button: nil, size: 12)
        setFont(TextField: nil, label: labelDropValue, Button: nil, size: 10)
        setFont(TextField: nil, label: labelDrop, Button: nil, size: 12)
        setFont(TextField: nil, label: labelAddress, Button: nil, size: 10)
    }
    
    func setRoundCorner(){
        self.userProfile.cornerRadius = self.userProfile.frame.height / 2
        self.userProfile.clipsToBounds = true
        self.viewMessage.makeRoundedCorner()
    }
}
