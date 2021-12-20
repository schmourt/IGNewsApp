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
}
