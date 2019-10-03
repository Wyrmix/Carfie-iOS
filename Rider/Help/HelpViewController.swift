//
//  helpViewController.swift
//  User
//
//  Created by CSS on 08/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import KWDrawerController

class NewHelpViewController: UIViewController {
    static func viewController() -> NewHelpViewController {
        let interactor = HelpInteractor()
        let viewController = NewHelpViewController(interactor: interactor)
        interactor.viewController = viewController
        return viewController
    }

    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Support"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    let supportImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "help")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var callButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.text = nil
        button.setImage(UIImage(named: "phone"), for: .normal)
        return button
    }()

    var messageButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.text = nil
        button.setImage(UIImage(named: "envelope"), for: .normal)
        return button
    }()

    var homePageButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.text = nil
        button.setImage(UIImage(named: "web"), for: .normal)
        return button
    }()

    var helpDescriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Our team will contact you soon!"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let interactor: HelpInteractor

    init(interactor: HelpInteractor) {
        self.interactor = interactor

        super.init(nibName: nil, bundle: nil)

        let buttonStackView = UIStackView(arrangedSubviews: [callButton, messageButton, homePageButton])
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually

        let containerStackView = UIStackView(arrangedSubviews: [titleLabel, supportImageView, buttonStackView, helpDescriptionLabel])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = 44

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
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        navigationItem.title = Constants.string.help.localize()

        addButtonTargets()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        [callButton, messageButton, homePageButton].forEach {
            $0.backgroundColor = .carfieBlue
            $0.makeRoundedCorner()
        }
    }

    private func addButtonTargets() {
        callButton.addTarget(interactor, action: #selector(interactor.callSupportButtonPressed), for: .touchUpInside)
        messageButton.addTarget(interactor, action: #selector(interactor.sendEmailButtonPressed), for: .touchUpInside)
        homePageButton.addTarget(interactor, action: #selector(interactor.viewHomePageButtonPressed), for: .touchUpInside)
    }
}

// MARK:- MFMailComposeViewControllerDelegate

extension NewHelpViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

class HelpViewController: UIViewController {
    
    @IBOutlet var supportLabel: UILabel!
    @IBOutlet var helpImage: UIImageView!
//    @IBOutlet var callImage: UIImageView!
//    @IBOutlet var messageImage: UIImageView!
//    @IBOutlet var webImage: UIImageView!
    @IBOutlet var HelpQuotesLabel: UILabel!
    
    @IBOutlet var viewButtons: [UIView]!
    
    @IBOutlet var callButton: UIButton!
    
    @IBOutlet var messageButton: UIButton!
    
    @IBOutlet var webButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        buttonAction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewButtons.forEach({ $0.makeRoundedCorner() })
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//    }
//
}

extension HelpViewController {
    
    // MARK:- Set Design
    
    private func setDesign () {
        
        Common.setFont(to: supportLabel, isTitle: true)
        Common.setFont(to: HelpQuotesLabel)
        
        supportLabel.text = Constants.string.Support.localize()
        HelpQuotesLabel.text = Constants.string.helpQuotes.localize()
        
    }
    
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.help.localize()
        self.setDesign()
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
    }
    
    private func buttonAction(){
        self.callButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.messageButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.webButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.callButton.tag = 1
        self.messageButton.tag = 2
        self.webButton.tag = 3
        
    }
    
    @IBAction func Buttontapped(sender: UIButton){
        if sender.tag == 1{
            Common.call(to: supportNumber)
        }else if sender.tag == 2{
            Common.sendEmail(to: [supportEmail], from: self)
            
        }else if sender.tag == 3 {
            
            guard let url = URL(string: baseUrl) else {
                UIScreen.main.focusedView?.make(toast: Constants.string.couldNotReachTheHost.localize())
                return
            }
            
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
        
    }
}

// MARK:- MFMailComposeViewControllerDelegate

extension HelpViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}

//MARK:- SFSafariViewControllerDelegate

extension HelpViewController : SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.popOrDismiss(animation: true)
    }
}

