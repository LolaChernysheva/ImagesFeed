//
//  ProfileViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import UIKit

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
        return button
    }()
    
    var presenter: ProfilePresenterProtocol!
    private var model: ProfileModel = .empty {
        didSet {
            displayProfile(with: model)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter.loadProfile()
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
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: Metrics.exitBtnWidth),
            exitButton.heightAnchor.constraint(equalToConstant: Metrics.exitBtnHeight),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.insets)
        ])
    }
    
    private func configureUserNameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: Metrics.spacer),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.insets),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.insets),
            usernameLabel.heightAnchor.constraint(equalToConstant: Metrics.labelHeight)
        ])
    }
    
    private func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.avatarWidteight),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.avatarWidteight),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metrics.insets),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.insets)
        ])
        profileImageView.layer.cornerRadius = Metrics.avatarWidteight / 2
        profileImageView.clipsToBounds = true
    }
    
    private func configureBioLabel() {
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: Metrics.spacer),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.insets),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.insets),
            bioLabel.heightAnchor.constraint(equalToConstant: Metrics.labelHeight)
            
        ])
    }
    
    private func configureHandleLabel() {
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: Metrics.spacer),
            handleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.insets),
            handleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.insets),
            handleLabel.heightAnchor.constraint(equalToConstant: Metrics.labelHeight)
        ])
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func displayProfile(with model: ProfileModel) {
        usernameLabel.text = model.fullName
        handleLabel.text = model.nikName
        bioLabel.text = model.bio
        profileImageView.image = UIImage(named: model.avatarString ?? "person.crop.circle.fill")
    }
}

fileprivate struct Metrics {
    static let avatarWidteight: CGFloat = 70
    static let insets: CGFloat = 16
    static let spacer: CGFloat = 8
    static let labelHeight: CGFloat = 18
    static let exitBtnWidth: CGFloat = 20
    static let exitBtnHeight: CGFloat = 22
}
