//
//  RateView.swift
//  User
//
//  Created by CSS on 14/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RateView: UIView {
    
    @IBOutlet private weak var imageView : UIImageView!
    
    @IBOutlet private weak var labelServiceName : UILabel! {
        didSet {
            labelServiceName.font = .carfieHeading
        }
    }
    
    @IBOutlet private weak var labelBaseFareString : UILabel! {
        didSet {
            labelBaseFareString.text = "Carfie Fare"
            labelBaseFareString.font = .carfieBodyBold
            labelBaseFareString.textColor = .carfieMidGray
        }
    }
    
    @IBOutlet private weak var labelBaseFare : UILabel! {
        didSet {
            labelBaseFare.font = .carfieBody
            labelBaseFare.textAlignment = .right
        }
    }
    
    @IBOutlet private weak var labelCapacity : UILabel! {
        didSet {
            labelCapacity.font = .carfieBody
        }
    }
    
    @IBOutlet private weak var labelCapacityString : UILabel! {
        didSet {
            labelCapacityString.text = "Capacity"
            labelCapacityString.font = .carfieBodyBold
            labelCapacityString.textColor = .carfieMidGray
        }
    }
    
    @IBOutlet private weak var buttonDone: CarfieSecondaryButton! {
        didSet {
            buttonDone.setTitle("Done", for: .normal)
        }
    }
    
    var onCancel : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonDone.addTarget(self, action: #selector(self.buttonDoneAction), for: .touchUpInside)
    }
}

extension RateView {
    
    // MARK:- Set Values
    
    func set(values: Service?) {
        
        Cache.image(forUrl: values?.image) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        labelBaseFare.text = "$\(Formatter.shared.limit(string: "\(values?.pricing?.estimated_fare ?? 0)", maximumDecimal: 2))"
        labelCapacity.text = "1 - \(values?.capacity ?? 0)"
        labelServiceName.text = values?.name?.uppercased()
    }
    
    @IBAction private func buttonDoneAction() {
        self.onCancel?()
    }
}
