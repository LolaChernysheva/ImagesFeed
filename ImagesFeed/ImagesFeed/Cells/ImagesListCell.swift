//
//  ImagesListCell.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 15.11.2023.
//  
//

import UIKit

struct ImageCellViewModel {
    let imageName: String
    let text: String
    let likeImageName: String
    
    let action: (() -> (Void))?
    let likeAction: (() -> Void)?
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Metrics.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var likeButton = UIButton()
    private var gradientLayer: CAGradientLayer?
    
    private var action: (() -> Void)?
    private var likeAction: (() -> Void)?
    
    
    var viewModel: ImageCellViewModel? {
        didSet {
            image.image = UIImage(named: viewModel?.imageName ?? "")
            label.text = viewModel?.text
            likeButton.setImage(UIImage(named: viewModel?.likeImageName ?? ""), for: .normal)
            action = viewModel?.action
            likeAction = viewModel?.likeAction
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCell() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(gradientView)
        image.addSubview(label)
        image.addSubview(likeButton)
        contentView.backgroundColor = .clear
        setupContainerView()
        setupImage()
        setupGradientView()
        setupLabel()
        setupLikeButton()
    }
    
    private func setupGradientView() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: image.topAnchor),
            gradientView.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
        
        addGradient()
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        containerView.backgroundColor = .clear
    }
    
    private func setupImage() {
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metrics.imageInsets),
            image.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Metrics.leadingTrailingInsets),
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.leadingTrailingInsets),
            image.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Metrics.imageInsets),
        ])
    }
    
    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: Metrics.insets),
            label.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -Metrics.insets),
            label.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -Metrics.insets),
            label.widthAnchor.constraint(equalToConstant: Metrics.labelWidth)
        ])
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: image.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: Metrics.buttonWidthHeight),
            likeButton.heightAnchor.constraint(equalToConstant: Metrics.buttonWidthHeight)
        ])
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        let colorTop = UIColor.ypGradient.withAlphaComponent(0).cgColor
        let colorBottom = UIColor.ypGradient.withAlphaComponent(0.2).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.7, 1.0]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }
}

fileprivate struct Metrics {
    static let insets: CGFloat = 8
    static let labelWidth: CGFloat = 18
    static let buttonWidthHeight: CGFloat = 44
    static let cornerRadius: CGFloat = 16
    static let imageInsets: CGFloat = 4
    static let leadingTrailingInsets: CGFloat = 16
}
