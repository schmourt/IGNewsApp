//
//  ReportDetailViewController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/17/21.
//

import UIKit

class ReportDetailViewController: UIViewController {
    private let report: Report
    private let viewModel = DashboardViewModel()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
        label.textAlignment = .left
        label.text  = report.title
        
        return label
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textAlignment = .left
        label.text  = "Last updated: \(report.updatedTimestamp)"
        
        return label
    }()
    
    private lazy var articleImage: UIImageView = {
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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.textAlignment = .left
        label.text = report.description
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textAlignment = .left
        label.text  = "Written by: \(report.authors)"
        
        return label
    }()
    
    private lazy var authorImage: UIImageView = {
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
    
    private lazy var viewOnWebButton: UIButton = {
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
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        return view
    }()
    
    private lazy var authorStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.addSubview(reportStackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var reportStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        
        return stackView
    }()
    
    

    init(report: Report) {
        self.report = report
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        /// Populate the report image
        viewModel.getImageForURL(urlString: report.reportImageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.articleImage.image = image
            }
        }
        
        /// Populate fhe author image
        viewModel.getImageForURL(urlString: report.authorImageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.authorImage.image = image
            }
        }
    }
    
    private func setUpViews() {
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
        
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
        self.navigationController?.pushViewController(WebViewController(url: report.url), animated: false)
    }
}
