//
//  AnimatedWelcomeCell.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class WelcomeCarouselTextCell: UICollectionViewCell, WelcomeCell {
    
    static let reuseIdentifier = "TextWelcomeCell"
    
    weak var delegate: WelcomeCellDelegate?
    
    // MARK: UI Components
    
    private var boldLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
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
        [boldLabel, bottomLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            $0.textAlignment = .center
            $0.numberOfLines = 3
        }
        
        addSubview(boldLabel)
        addSubview(bottomLabel)
        
        let container = UILayoutGuide()
        addLayoutGuide(container)
        
        NSLayoutConstraint.activate([
            boldLabel.topAnchor.constraint(equalTo: container.topAnchor),
            boldLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            boldLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            bottomLabel.topAnchor.constraint(equalTo: boldLabel.bottomAnchor, constant: 24),
            bottomLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func configure(with viewState: WelcomeCarouselCellViewState) {
        boldLabel.text = viewState.boldText
        bottomLabel.text = viewState.bottomLabelText
    }
}
