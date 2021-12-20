//
//  ReportDetailView.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/20/21.
//

import UIKit

class ReportDetailView: UIView {
    private let viewModel: ReportCellViewModel

    var onButtonTapped: ((_ string: String)->())? = nil

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
        label.textAlignment = .left
        label.text  = viewModel.title

        return label
    }()

    lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textAlignment = .left
        label.text  = "Last updated: \(viewModel.updatedTimestamp)"

        return label
    }()

    lazy var articleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.backgroundColor?.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        return imageView
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.textAlignment = .left
        label.text = viewModel.description

        return label
    }()

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textAlignment = .left
        label.text  = "Written by: \(viewModel.authors)"

        return label
    }()

    lazy var authorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.backgroundColor?.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        return imageView
    }()

    lazy var viewOnWebButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitle("Tap to view on web", for: .normal)
        button.backgroundColor = .tertiarySystemBackground
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)

        return button
    }()

    lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        return view
    }()

    lazy var authorStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8

        return stackView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

            scrollView.addSubview(reportStackView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = true
            return scrollView
    }()

    lazy var reportStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20

        return stackView
    }()

    init(viewModel: ReportCellViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        self.setUpViews()
        
        viewModel.getImageForURL(urlString: viewModel.authorImageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.authorImage.image = image
            }
        }

        viewModel.getImageForURL(urlString: viewModel.reportImageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.articleImage.image = image
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        addSubview(scrollView)

        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        reportStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        reportStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        reportStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        reportStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        reportStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        authorStackView.addArrangedSubview(authorImage)
        authorStackView.addArrangedSubview(authorLabel)

        reportStackView.addArrangedSubview(titleLabel)
        reportStackView.addArrangedSubview(timestampLabel)
        reportStackView.addArrangedSubview(articleImage)
        reportStackView.addArrangedSubview(descriptionLabel)
        reportStackView.addArrangedSubview(authorStackView)
        reportStackView.addArrangedSubview(viewOnWebButton)
        reportStackView.addArrangedSubview(spacerView)
    }

    @objc func tappedButton() {
        onButtonTapped?(viewModel.url)
    }
}
