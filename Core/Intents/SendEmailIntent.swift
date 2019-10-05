//
//  SendEmailIntent.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/4/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import MessageUI
import UIKit

final class SendEmailIntent: NSObject {

    private let mailComposeViewController: MFMailComposeViewController

    init(recipients: [String], subject: String, body: String? = nil, bodyIsHTML: Bool = false) {
        mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.setToRecipients(recipients)
        mailComposeViewController.setSubject(subject)

        if let body = body {
            mailComposeViewController.setMessageBody(body, isHTML: bodyIsHTML)
        }

        super.init()
    }

    func execute(via presenter: UIViewController & MFMailComposeViewControllerDelegate) {
        guard MFMailComposeViewController.canSendMail() else {
            UIScreen.main.focusedView?.make(toast: CarfieContact.Error.genericEmailError)
            return
        }

        mailComposeViewController.mailComposeDelegate = presenter
        presenter.present(mailComposeViewController, animated: true)
    }
}

extension SendEmailIntent {
    static func emailCarfieSupport() -> SendEmailIntent {
        return SendEmailIntent(recipients: [CarfieContact.supportEmail], subject: CarfieContact.supportEmailSubject)
    }
}
