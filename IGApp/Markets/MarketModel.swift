//
//  MarketModel.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/18/21.
//

import Foundation

// MARK: - MarketModel
struct MarketModel: Codable {
    let currencies, commodities, indices: [Commodity]?
}

// MARK: - Commodity
struct Commodity: Codable {
    let displayName, marketID, rateDetailURL: String?

    enum CodingKeys: String, CodingKey {
        case marketID = "marketId"
        case displayName, rateDetailURL
    }
}

enum CommodityType: Int, Hashable {
    case currencies, commodities, indices
    
    var name: String {
        switch self {
        case .currencies:
            return "Currencies"
        case .commodities:
            return "Commodities"
        case .indices:
            return "Indices"
        }
    }
}
