//
//  MarketsViewModel.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/18/21.
//

import Foundation

class MarketsViewModel {
    let networkInterface = NetworkInterface()
    
    var marketDictionary = [CommodityType : [Commodity]]()
    
    /// Get the market data from the API layer and populate the dictionary for the tableview
    /// - Parameter completion: alerts tableview that dictionary has loaded
    func getMarketData(completion: @escaping ()->()) {
        networkInterface.getMarketData { [weak self] data in
            self?.formatMarketData(data: data)
            completion()
        }
    }
    
    /// Format the data into types used for UI
    /// - Parameter data: data passed through from network
    func formatMarketData(data: MarketModel) {
        var dictionary = [CommodityType : [Commodity]]()
        
        guard let currencies = data.currencies,
              let commodities = data.commodities,
              let indices = data.indices else {
            return
        }
        
        dictionary[.currencies] = currencies
        dictionary[.commodities] = commodities
        dictionary[.indices] = indices
        
        self.marketDictionary = dictionary
    }

    func getURLString(for indexPath: IndexPath) -> String {
        guard let commodityType = CommodityType(rawValue: indexPath.section),
              let commodities = marketDictionary[commodityType],
              let urlString =  commodities[indexPath.row].rateDetailURL else {
            return ""
        }

        return urlString
    }

    func getNumberOfRowsInSection(section: Int) -> Int {
        guard let commodityType = CommodityType(rawValue: section), let commodities = marketDictionary[commodityType] else {
            return 0
        }

        return commodities.count
    }

    func getTitleForSection(section: Int) -> String {
        guard let commodityType = CommodityType(rawValue: section) else {
            return ""
        }

        return commodityType.name.uppercased()
    }

    func getCellText(for indexPath: IndexPath) -> (displayName: String, marketID: String) {
        guard let commodityType = CommodityType(rawValue: indexPath.section),
              let commodities = marketDictionary[commodityType],
              let displayName = commodities[indexPath.row].displayName,
              let marketID = commodities[indexPath.row].marketID else {
            return ("N/A", "N/A")
        }

        return (displayName, marketID)
    }

    func getNumberOfSections() -> Int {
        return marketDictionary.keys.count
    }
}
