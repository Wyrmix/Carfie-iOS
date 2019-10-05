//
//  HelpInteractor.swift
//  Rider
//
//  Created by Christopher Olsen on 10/2/19.
//

import MessageUI
import UIKit

class HelpInteractor {

    weak var viewController: HelpViewController?

    init() {}

    @objc func callSupportButtonPressed() {
        PhoneCallIntent.callCarfieSupport()?.execute()
    }

    @objc func sendEmailButtonPressed() {
        guard let viewController = viewController else { return }
        SendEmailIntent.emailCarfieSupport().execute(via: viewController)
    }

    @objc func viewHomePageButtonPressed() {
        guard let viewController = viewController else { return }
        SafariIntent.openCarfieWebsite()?.execute(via: viewController)
    }
}

extension HelpViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            UIScreen.main.focusedView?.make(toast: CarfieContact.Error.genericEmailError)
        }


        controller.dismiss(animated: true, completion: nil)
    }
}