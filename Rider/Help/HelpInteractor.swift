//
//  HelpInteractor.swift
//  Rider
//
//  Created by Christopher Olsen on 10/2/19.
//

import UIKit

class HelpInteractor {

    weak var viewController: NewHelpViewController?

    init() {}

    @objc func callSupportButtonPressed() {
        PhoneCallIntent.callCarfieSupport()?.execute()
    }

    @objc func sendEmailButtonPressed() {
        guard let viewController = viewController else { return }
        Common.sendEmail(to: [CarfieContact.supportEmail], from: viewController)
    }

    @objc func viewHomePageButtonPressed() {
        guard let viewController = viewController else { return }
        SafariIntent(url: WebPage.carfieHomePage)?.execute(via: viewController)
    }
}
