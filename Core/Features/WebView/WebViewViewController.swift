//
//  WebViewViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/6/19.
//

import WebKit
import UIKit

class WebViewViewController: UIViewController {
    static func viewController(url: URL) -> WebViewViewController {
        let viewController = WebViewViewController(url: url)
        return viewController
    }

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.carfieBlue, for: .normal)
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    private let url: URL

    init(url: URL) {
        self.url = url

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        webView.navigationDelegate = self

        view.addSubview(doneButton)
        view.addSubview(webView)
        webView.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 8),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
    }

    @objc func doneButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicatorView.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
}
