//
//  OpenURLIntent.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/4/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol URLIntent {
    func execute()
}

/// Generic open URL intent to be used as a Decorator with other URLIntents.
/// It ensures that basic logic, such as checking if a URL can be opened, is
/// checked on every intent execution.
final class OpenUrlIntent {
    private let url: URL
    private let intent: URLIntent

    init(url: URL, intent: URLIntent) {
        self.url = url
        self.intent = intent
    }

    func execute() {
        guard UIApplication.shared.canOpenURL(url) else {
            assertionFailure("URL scheme cannot be opened.")
            return
        }

        intent.execute()
    }
}
