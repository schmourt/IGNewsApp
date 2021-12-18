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
    
    func getMarketData(completion: @escaping ()->()) {
        
        var dictionary = [CommodityType : [Commodity]]()
        
        networkInterface.getMarketData { [weak self] data in
            
            guard let currencies = data.currencies,
                  let commodities = data.commodities,
                  let indices = data.indices else {
                return
            }
            
            dictionary[.currencies] = currencies
            dictionary[.commodities] = commodities
            dictionary[.indices] = indices
            
            self?.marketDictionary = dictionary
            
            completion()
        }
    }
}
