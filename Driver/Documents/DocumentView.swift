//
//  DocumentView.swift
//  Carfie
//
//  Created by Christopher.Olsen on 11/5/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol DocumentViewDelegate: class {
    func uploadButtonPressed(for type: DriverDocumentType)
}

class DocumentView: UIView {
    
    weak var delegate: DocumentViewDelegate?
    
    private var type: DriverDocumentType?
    
    // MARK: UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .carfieHeadingBold
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let uploadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.setImage(UIImage(named: "SquareUploadArrow"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: Inits
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }
    
    // MARK: View Setup
    
    private func setup() {
        backgroundColor = .clear
        
        uploadButton.addTarget(self, action: #selector(uploadButtonTouchUpInside(_:)), for: .touchUpInside)
        uploadButton.backgroundColor = .white
        uploadButton.layer.cornerRadius = 12
        
        addSubview(titleLabel)
        addSubview(uploadButton)
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            uploadButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            uploadButton.widthAnchor.constraint(equalTo: widthAnchor),
            uploadButton.heightAnchor.constraint(equalTo: uploadButton.widthAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            uploadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func configure(with item: DocumentItem) {
        type = item.type
        titleLabel.text = item.title
        
        if item.isUploaded {
            uploadButton.setImage(UIImage(named: "GreenCircleCheckmark"), for: .normal)
        } else {
            uploadButton.setImage(UIImage(named: "SquareUploadArrow"), for: .normal)
        }
    }
    
    // MARK: Selectors
    
    @objc private func uploadButtonTouchUpInside(_ selector: Any?) {
        guard let type = type else { return }
        delegate?.uploadButtonPressed(for: type)
    }
}
