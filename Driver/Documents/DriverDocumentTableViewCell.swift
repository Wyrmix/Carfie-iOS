//
//  DriverDocumentTableViewCell.swift
//  Driver
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DriverDocumentsTableViewCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private var documentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .carfieBlue
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        containerView.addSubview(documentImageView)
        containerView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            actionButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            
            documentImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            documentImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            documentImageView.widthAnchor.constraint(equalToConstant: 200),
            documentImageView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func configure(with viewModel: DriverDocumentCellViewModel) {
        titleLabel.text = viewModel.title.uppercased()
        documentImageView.image = viewModel.image ?? UIImage(named: "emptyImage")
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    }
}
