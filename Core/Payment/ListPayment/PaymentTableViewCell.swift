//
//  PaymentTableViewCell.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PaymentCardCell"
    
    // MARK: UI Components
    
    private let paymentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .carfieBody
        return label
    }()
    
    // MARK: Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setup() {    
        addSubview(paymentImageView)
        addSubview(paymentLabel)
        
        NSLayoutConstraint.activate([
            paymentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            paymentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            paymentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            paymentImageView.widthAnchor.constraint(equalTo: paymentImageView.heightAnchor),
            
            paymentLabel.leadingAnchor.constraint(equalTo: paymentImageView.trailingAnchor, constant: 16),
            paymentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            paymentLabel.centerYAnchor.constraint(equalTo: paymentImageView.centerYAnchor),
        ])
    }
    
    func configure(with viewModel: PaymentTableViewCellViewModel) {
        paymentImageView.image = viewModel.image
        paymentLabel.text = viewModel.text
    }
}
