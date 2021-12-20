//
//  DashboardTableViewController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import UIKit

class DashboardTableViewController: UITableViewController {
    
    let viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Daily FX"
    
        tableView.tableFooterView = UIView()
        
        viewModel.getReports { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let report = viewModel.getReport(for: indexPath) else {
            return
        }
        
        self.navigationController?.pushViewController(ReportDetailViewController(viewModel: report), animated: false)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitleForSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let report = viewModel.getReport(for: indexPath) else {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        
        cell.textLabel?.text = report.title
        cell.detailTextLabel?.text = "\n\(report.description)\n\n\(report.authors)\n\(report.timestamp)"
        
        return cell
    }
}
