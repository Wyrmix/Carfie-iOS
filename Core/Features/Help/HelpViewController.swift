//
//  helpViewController.swift
//  User
//
//  Created by Christopher Olsen on 10/2/19.
//  Copyright © 2019 Carfie. All rights reserved.
//


import MessageUI
import SafariServices
import KWDrawerController
import UIKit

class HelpViewController: UIViewController {
    static func viewController() -> HelpViewController {
        let interactor = HelpInteractor()
        let viewController = HelpViewController(interactor: interactor)
        interactor.viewController = viewController
        return viewController
    }

    let supportImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "help")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var callButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "phone"), for: .normal)
        return button
    }()

    var messageButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "envelope"), for: .normal)
        return button
    }()

    var homePageButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "web"), for: .normal)
        return button
    }()

    var helpDescriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Our team will contact you soon!"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    var privacyPolicyButton: UIButton = {
        var button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.carfieBlue, for: .normal)
        return button
    }()

    private let interactor: HelpInteractor

    init(interactor: HelpInteractor) {
        self.interactor = interactor

        super.init(nibName: nil, bundle: nil)

        let buttonStackView = UIStackView(arrangedSubviews: [callButton, messageButton, homePageButton])
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually

        let containerStackView = UIStackView(arrangedSubviews: [supportImageView, buttonStackView, helpDescriptionLabel, privacyPolicyButton])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = 36

        view.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            supportImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            supportImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.67),
            callButton.heightAnchor.constraint(equalToConstant: 50),
            callButton.widthAnchor.constraint(equalToConstant: 50),
            messageButton.heightAnchor.constraint(equalToConstant: 50),
            messageButton.widthAnchor.constraint(equalToConstant: 50),
            homePageButton.heightAnchor.constraint(equalToConstant: 50),
            homePageButton.widthAnchor.constraint(equalToConstant: 50),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popOrDismiss))
        navigationItem.title = "Help"

        addButtonTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        [callButton, messageButton, homePageButton].forEach {
            $0.backgroundColor = .carfieBlue
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
    }

    private func addButtonTargets() {
        callButton.addTarget(interactor, action: #selector(interactor.callSupportButtonPressed), for: .touchUpInside)
        messageButton.addTarget(interactor, action: #selector(interactor.sendEmailButtonPressed), for: .touchUpInside)
        homePageButton.addTarget(interactor, action: #selector(interactor.viewHomePageButtonPressed), for: .touchUpInside)
        privacyPolicyButton.addTarget(interactor, action: #selector(interactor.viewPrivacyPolicyButtonPressed), for: .touchUpInside)
    }
}
