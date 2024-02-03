//
//  SingleImageViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import UIKit
import Kingfisher

fileprivate extension CGFloat {
    static let shareButtonSize: CGFloat = 50
}

protocol SingleImageViewProtocol: AnyObject {
    func showActivityController()
    func displayData(data: SingleImageScreenModel)
}

final class SingleImageViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let photoView = UIImageView()
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    private let sharedButton = UIButton()
    
    private let scrollView = UIScrollView()
    
    var presenter: SingleImagePresenterProtocol!
    
    private var screenModel: SingleImageScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.setup()
        sharedButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    private func setup() {
        sharedButton.setImage(UIImage(named: screenModel.sharedImageName), for: .normal)
        let imageURL = URL(string: screenModel.imageName)
        imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "person.crop.circle.fill"))
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(sharedButton)
        setupScrollView()
        setupImage()
        setupSharingButton()
        setupNavigationBar()
      }
    
    private func setupNavigationBar() {
        let backItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        backItem.tintColor = .white
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.layoutMargins.top),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.layoutMargins.bottom)
        ])
    }
    
    private func setupSharingButton() {
        sharedButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sharedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            sharedButton.widthAnchor.constraint(equalToConstant: .shareButtonSize),
            sharedButton.heightAnchor.constraint(equalToConstant: .shareButtonSize)
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func shareButtonTapped() {
        presenter.shareButtonTapped()
    }
}

extension SingleImageViewController: SingleImageViewProtocol {
    
    func displayData(data: SingleImageScreenModel) {
        screenModel = data
    }
    
    func showActivityController() {
        guard let image = imageView.image else { return }
        let items = [image]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}
