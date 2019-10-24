//
//  WelcomeCarouselCollectionViewCell.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/21/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class WelcomeCarouselCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI components
    
    private var topLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private var actionButton: CarfieButton?
    
    // MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellStackView.arrangedSubviews.forEach {
            cellStackView.removeArrangedSubview($0)
        }
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
            cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    // MARK: Public view conmfiguration
    
    /// Configure the cell's UI components.
    /// - Parameter viewState: ViewState object that represents the configuration for the cell.
    func configure(with viewState: WelcomeCarouselCellViewState) {
        // Order of operations is important here. It will determine the order the items appear
        // in the cell StackView.
        setupTopLabel(with: viewState.topLabelText)
        setupImageView(with: viewState.image)
        boldLabel.text = viewState.boldText
        cellStackView.addArrangedSubview(boldLabel)
        setupBottomLabel(with: viewState.bottomLabelText)
        setupActionButton(isVisible: viewState.showActionButton, withTheme: viewState.theme)
    }
    
    // MARK: Private view configuration
    
    private func setupImageView(with image: UIImage?) {
        guard let image = image else { return }
        
        imageView.image = image
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        cellStackView.addArrangedSubview(imageView)
    }
    
    private func setupTopLabel(with text: String?) {
        guard let text = text else { return }
        
        topLabel.text = text
        cellStackView.addArrangedSubview(topLabel)
    }
    
    private func setupBottomLabel(with text: String?) {
        guard let text = text else { return }
        
        bottomLabel.text = text
        cellStackView.addArrangedSubview(bottomLabel)
    }
    
    private func setupActionButton(isVisible: Bool, withTheme theme: AppTheme) {
        guard isVisible else { return }
        
        // We only want to create this button once or we'll get duplicate buttons in
        // the stack view.
        if actionButton == nil {
            actionButton = CarfieButton(theme: theme, style: .smallPrimary)
        }
        
        actionButton?.setTitle("Details", for: .normal)
        
        guard actionButton != nil else { return }
        
        NSLayoutConstraint.activate([
            actionButton!.widthAnchor.constraint(equalToConstant: 120),
            actionButton!.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        cellStackView.addArrangedSubview(actionButton!)
    }
}
