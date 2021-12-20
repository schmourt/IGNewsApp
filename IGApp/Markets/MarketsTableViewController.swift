//
//  MarketsViewController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import UIKit

class MarketsTableViewController: UITableViewController {
    let viewModel = MarketsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Markets"
    
        tableView.tableFooterView = UIView()
        
        viewModel.getMarketData { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = viewModel.getURLString(for: indexPath)
        
        self.navigationController?.pushViewController(WebViewController(url: urlString), animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        let text = viewModel.getCellText(for: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.textLabel?.text = text.displayName
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.text = text.displayName
        cell.detailTextLabel?.text = text.marketID

        return cell
    }
}
