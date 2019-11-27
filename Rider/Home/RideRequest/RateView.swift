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
            labelServiceName.text = "CARFIE"
            labelServiceName.font = .carfieHeading
        }
    }
    
    @IBOutlet weak var rideDescriptionLabel: UILabel! {
        didSet {
            rideDescriptionLabel.font = .carfieBody
            rideDescriptionLabel.textColor = .carfieMidGray
            rideDescriptionLabel.textAlignment = .center
            rideDescriptionLabel.numberOfLines = 2
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
        
        guard let service = values else { return }
        
        Cache.image(forUrl: service.image) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        labelBaseFare.text = "$\(Formatter.shared.limit(string: "\(service.pricing?.estimated_fare ?? 0)", maximumDecimal: 2))"
        labelCapacity.text = "1 - \(service.capacity ?? 0)"
        
        guard let name = service.name else { return }
        
        rideDescriptionLabel.text = service.rideDescription
        labelBaseFareString.text = "\(name) Fare"
        labelServiceName.text = name.uppercased()
    }
    
    @IBAction private func buttonDoneAction() {
        self.onCancel?()
    }
}

private extension Service {
    var rideDescription: String {
        switch self.id {
        case 1:
            return "Affordable everyday ride. Fits up to 4 people."
        case 2:
            return "Newer car with more space."
        case 3:
            return "Large Family sized ride with more space."
        case 4:
            return "Large Family sized ride in Luxury with more space."
        case 7:
            return "4-Seater ride in Luxury style."
        default:
            return ""
        }
    }
}
