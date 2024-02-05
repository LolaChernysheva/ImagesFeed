//
//  ProfileViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import UIKit
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    func displayProfile(with model: ProfileModel)
}

final class ProfileViewController: UIViewController {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor.ypWhite
        return label
    }()
    
    let handleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor.ypGray
        return label
    }()
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor.ypWhite
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.tintColor = UIColor.ypRed
        button.accessibilityIdentifier = AccessibilityIdentifiers.Buttons.logoutButton
        return button
    }()
    
    var presenter: ProfilePresenterProtocol!
    
    private var model: ProfileModel = .empty {
        didSet {
            displayProfile(with: model)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.fetchUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(handleLabel)
        view.addSubview(bioLabel)
        view.addSubview(exitButton)
        
        configureProfileImageView()
        configureUserNameLabel()
        configureHandleLabel()
        configureBioLabel()
        configureExitButton()
    }
    
    private func configureExitButton() {
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: .exitBtnWidth),
            exitButton.heightAnchor.constraint(equalToConstant: .exitBtnHeight),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets)
        ])
    }
    
    private func configureUserNameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: .spacer),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            usernameLabel.heightAnchor.constraint(equalToConstant: .labelHeight)
        ])
    }
    
    private func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: .avatarWidteight),
            profileImageView.heightAnchor.constraint(equalToConstant: .avatarWidteight),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .insets),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets)
        ])
        profileImageView.layer.cornerRadius = .avatarWidteight / 2
        profileImageView.clipsToBounds = true
    }
    
    private func configureBioLabel() {
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: .spacer),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            bioLabel.heightAnchor.constraint(equalToConstant: .labelHeight)
            
        ])
    }
    
    private func configureHandleLabel() {
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: .spacer),
            handleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            handleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            handleLabel.heightAnchor.constraint(equalToConstant: .labelHeight)
        ])
    }
    
    @objc private func exitButtonTapped() {
        showExitAlert()
    }
    
    private func showExitAlert() {
        let logoutAlert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            self.presenter.logout()
        }
        yesAction.accessibilityIdentifier = AccessibilityIdentifiers.Buttons.logoutAlertYesButton
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        logoutAlert.addActions([yesAction, noAction])
        present(logoutAlert, animated: true)
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func displayProfile(with model: ProfileModel) {
        guard let imageString = model.avatarString else {
            profileImageView.image = UIImage(named:"person.crop.circle.fill")
            return
        }
        let imageURL = URL(string: imageString)
        profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(named:"person.crop.circle.fill"))
        usernameLabel.text = model.fullName
        handleLabel.text = model.nikName
        bioLabel.text = model.bio
    }
}

fileprivate extension CGFloat {
    static let avatarWidteight: CGFloat = 70
    static let insets: CGFloat = 16
    static let spacer: CGFloat = 8
    static let labelHeight: CGFloat = 18
    static let exitBtnWidth: CGFloat = 20
    static let exitBtnHeight: CGFloat = 22
}
