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
        let dictionary = viewModel.marketDictionary
        
        guard let commodityType = CommodityType(rawValue: indexPath.section),
              let commodities = dictionary[commodityType],
              let urlString =  commodities[indexPath.row].rateDetailURL else {
            return
        }
        
        self.navigationController?.pushViewController(WebViewController(url: urlString), animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.marketDictionary.keys.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let commodityType = CommodityType(rawValue: section) else {
            return ""
        }
        
        return commodityType.name.uppercased()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictionary = viewModel.marketDictionary
        
        guard let commodityType = CommodityType(rawValue: section), let commodities = dictionary[commodityType] else {
            return 0
        }
        
        return commodities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictionary = viewModel.marketDictionary
        
        guard let commodityType = CommodityType(rawValue: indexPath.section),
              let commodities = dictionary[commodityType],
              let displayName = commodities[indexPath.row].displayName,
              let marketID = commodities[indexPath.row].marketID else {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        cell.textLabel?.text = displayName
        cell.detailTextLabel?.text = marketID
        
        return cell
    }
}
