//
//  SafariIntent.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/2/19.
//

import SafariServices

final class SafariIntent {

    private let url: URL

    init?(url: String) {
        guard let url = URL(string: url) else {
            assertionFailure("String is not a valid url.")
            return nil
        }

        self.url = url
    }

    func execute(via presenter: UIViewController) {
        let vc = SFSafariViewController(url: url)
        presenter.present(vc, animated: true)
    }
}
