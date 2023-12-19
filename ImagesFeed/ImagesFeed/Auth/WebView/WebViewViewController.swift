//
//  WebViewViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.12.2023.
//  
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) //webview получил код
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) //пользователь нажал кнопку назад и отменил авторизацию
}

protocol WebViewProtocol: AnyObject {
    func loadRequest(request: URLRequest)
}

final class WebViewViewController: UIViewController {
    
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenter!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.setupURL()
        webView.navigationDelegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath:
        #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    private func setupProgressView() {
        progressView.progressTintColor = UIColor.ypDarkBackground
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupView() {
        view.addSubview(webView)
        view.addSubview(progressView)
        setupWebViewContraints()
        configureNavBar()
        setupProgressView()
        
    }
    
    private func configureNavBar() {
        if let backButtonImage = UIImage(named: "Backward")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    private func setupWebViewContraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    @objc private func backButtonTapped() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    //метод вызывается, когда в результате действий пользователя WKWebView готовится совершить навигационные действия (например, загрузить новую страницу). Благодаря этому мы узнаем, когда пользователь успешно авторизовался.
    
    //navigationAction - Этот объект содержит информацию о том, что явилось причиной навигационных действий. С помощью него мы отделим событие успешной авторизации от прочих.
    
    //decisionHandler В этом методе его нужно выполнить, передав ему одно из трёх возможных значений (cancel, allow, download)
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = presenter.code(from: navigationAction) { //Она возвращает код авторизации, если он получен.
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel) //3 и код успешно получен, отменяем навигационное действие
        } else {
            decisionHandler(.allow) //4 Если код не получен, разрешаем навигационное действие. Возможно, пользователь просто переходит на новую страницу в рамках процесса авторизации.
        }
    }
}

extension WebViewViewController: WebViewProtocol {
    func loadRequest(request: URLRequest) {
        webView.load(request)
    }
}
