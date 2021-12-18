//
//  WebViewController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/17/21.
//

import WebKit

open class WebViewController: UIViewController {

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)

        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()
    
    let url: String

    init(url: String) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)

        self.webView.navigationDelegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)

        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        guard let url = URL(string: url) else {
            return
        }
        self.webView.load(URLRequest(url: url))
        
        
    }
}

extension WebViewController: WKNavigationDelegate {
    @objc func onBackButtonPressed(button: UIBarButtonItem) {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }

    @objc public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        if self.webView.canGoBack {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(onBackButtonPressed))
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
}
