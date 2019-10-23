//
//  WelcomeCarouselCollectionViewCell.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/21/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class WelcomeCarouselCollectionViewCell: UICollectionViewCell {
    
    private var topLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var boldLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private var actionButton: CarfieButton = {
        let button = CarfieButton(theme: .driver)
        return button
    }()
    
    private var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setup() {
        addSubview(cellStackView)
        
        [topLabel, boldLabel, bottomLabel].forEach {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.numberOfLines = 3
        }
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: topAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    /// Configure the cell's UI components.
    /// - Parameter viewState: ViewState object that represents the configuration for the cell.
    func configure(with viewState: WelcomeCarouselCellViewState) {
        // Order of operations is important here. It will determine the order the items appear
        // in the cell StackView.
        setupImageView(with: viewState.image)
        
        boldLabel.text = viewState.boldText
        cellStackView.addArrangedSubview(boldLabel)
        setupBottomLabel(with: viewState.bottomLabelText)
        setupActionButton(isVisible: viewState.showActionButton)
    }
    
    private func setupImageView(with image: UIImage?) {
        guard let image = image else { return }
        
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cellStackView.addArrangedSubview(imageView)
    }
    
    private func setupBottomLabel(with text: String?) {
        guard let text = text else { return }
        
        bottomLabel.text = text
        cellStackView.addArrangedSubview(bottomLabel)
    }
    
    private func setupActionButton(isVisible: Bool) {
        guard isVisible else { return }
        
        actionButton.setTitle("Details", for: .normal)
        
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        cellStackView.addArrangedSubview(actionButton)
    }
}
