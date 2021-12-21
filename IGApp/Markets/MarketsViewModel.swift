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
    
    /// Get the string for the web view when the cell is tapped
    /// - Parameter indexPath: the indexPath to look up the correct url from the dictionary
    func getURLString(for indexPath: IndexPath) -> String {
        guard let commodityType = CommodityType(rawValue: indexPath.section),
              let commodities = marketDictionary[commodityType],
              let urlString =  commodities[indexPath.row].rateDetailURL else {
            return ""
        }

        return urlString
    }
    
    /// Get the number of rows for thetableview section
    /// - Parameter section: indexpath section
    /// - Returns: number of items in the commodity type array in the dictionary
    func getNumberOfRowsInSection(section: Int) -> Int {
        guard let commodityType = CommodityType(rawValue: section), let commodities = marketDictionary[commodityType] else {
            return 0
        }

        return commodities.count
    }
    
    /// The title for the tableview section
    /// - Parameter section: indexpath section
    /// - Returns: title for the section, by looking up type name
    func getTitleForSection(section: Int) -> String {
        guard let commodityType = CommodityType(rawValue: section) else {
            return ""
        }

        return commodityType.name.uppercased()
    }
    
    /// A tuple with the text for the cell at the specified indexpath in the tableview
    /// - Parameter indexPath: indexpath to look up text for
    /// - Returns: tuple with the title and detail text
    func getCellText(for indexPath: IndexPath) -> (displayName: String, marketID: String) {
        guard let commodityType = CommodityType(rawValue: indexPath.section),
              let commodities = marketDictionary[commodityType],
              let displayName = commodities[indexPath.row].displayName,
              let marketID = commodities[indexPath.row].marketID else {
            return ("N/A", "N/A")
        }

        return (displayName, marketID)
    }
    
    /// Get the number of sections in the tableview
    /// - Returns: the number of sections in the tableview
    func getNumberOfSections() -> Int {
        return marketDictionary.keys.count
    }
}
