//
//  ReportDetailViewController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/17/21.
//

import UIKit

class ReportDetailViewController: UIViewController {

    var reportDetailView: ReportDetailView

    init(viewModel: ReportCellViewModel) {
        self.reportDetailView = ReportDetailView(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        reportDetailView.onButtonTapped = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view = reportDetailView

        reportDetailView.onButtonTapped = { [weak self] string in
            self?.navigationController?.pushViewController(WebViewController(url: string), animated: false)
        }
    }
}
