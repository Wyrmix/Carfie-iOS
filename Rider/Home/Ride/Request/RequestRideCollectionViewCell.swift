//
//  RequestRideCollectionViewCell.swift
//  Rider
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class RequestRideCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "RequestRideCell"
    
    // MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setup() {
        
    }
}
