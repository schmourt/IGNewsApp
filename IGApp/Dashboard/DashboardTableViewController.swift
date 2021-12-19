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
        let dictionary = viewModel.reportDictionary
        
        guard let newsType = ReportType(rawValue: indexPath.section), let reports = dictionary[newsType] else {
            return
        }
        
        let report = reports[indexPath.row]
        
        self.navigationController?.pushViewController(ReportDetailViewController(report: report), animated: false)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.reportDictionary.keys.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let newsType = ReportType(rawValue: section) else {
            return ""
        }
        
        return newsType.name.uppercased()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictionary = viewModel.reportDictionary
        
        guard let newsType = ReportType(rawValue: section), let articles = dictionary[newsType] else {
            return 0
        }
        
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictionary = viewModel.reportDictionary
        
        guard let reportType = ReportType(rawValue: indexPath.section),
              let reports = dictionary[reportType] else {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let article = reports[indexPath.row]
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        
        cell.textLabel?.text = reports[indexPath.row].title
        cell.detailTextLabel?.text = "\n\(article.description)\n\n\(article.authors)\n\(article.timestamp)"
        
        return cell
    }
}

