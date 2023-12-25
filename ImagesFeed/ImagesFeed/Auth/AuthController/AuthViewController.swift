//
//  AuthViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.12.2023.
//
//

import UIKit

fileprivate struct Metrics {
    static let sighInButtonHeight: CGFloat = 48
    static let insets: CGFloat = 16
    static let bottomInsets: CGFloat = 90
    static let logoSize: CGFloat = 60
    static let cornerRadius: CGFloat = 16
}

protocol AuthViewProtocol: UIViewController {
    func displayData(data: AuthScreenModel)
    var delegate: AuthViewControllerDelegate? { get }
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewProtocol, didAuthenticateWithCode code: String)
} 

final class AuthViewController: UIViewController {
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Metrics.cornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    private var logoImageView = UIImageView()
    
    private var screenModel: AuthScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    var presenter: AuthPresenter!
    weak var delegate: AuthViewControllerDelegate?
    
    init(delegate: AuthViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        configureView()
    }
    
    //MARK: - private methods
    
    private func setup() {
        view.backgroundColor = screenModel.backgroundColor
        logoImageView.image = screenModel.logoImage
        configureSignInButton()
    }
    
    private func configureView() {
        view.addSubview(signInButton)
        view.addSubview(logoImageView)
        setupSignInButtonConstraints()
        setupLogoConstraints()
    }
    
    private func configureSignInButton() {
        signInButton.setTitle(screenModel.buttonTitle, for: .normal)
        signInButton.backgroundColor = screenModel.buttonColor
        signInButton.setTitleColor(screenModel.backgroundColor, for: .normal)
        signInButton.titleLabel?.font = screenModel.font
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    private func setupSignInButtonConstraints() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: Metrics.sighInButtonHeight),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.insets),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.insets),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metrics.bottomInsets)
        ])
    }
    
    private func setupLogoConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Metrics.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Metrics.logoSize)
        ])
    }
    
    @objc private func signInButtonTapped() {
        presenter.signIn()
    }
}

extension AuthViewController: AuthViewProtocol {
    func displayData(data: AuthScreenModel) {
        self.screenModel = data
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
}
