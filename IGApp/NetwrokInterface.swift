//
//  NetwrokInterface.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import Foundation
import UIKit

class NetworkInterface {
    
    /// Load an image from a web url
    /// - Parameters:
    ///   - url: url hosting the image
    ///   - completion: the image from the url
    func getImage(url: URL, completion: @escaping (UIImage)->()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                fatalError("Error decoding image data \(error!)")
            }
            
            completion(image)
        }.resume()
    }
    
    /// Load reports for the dashboard
    /// - Parameter completion: network report codable type
    func getReports(completion: @escaping (ReportModel)->()) {
        guard let url = URL(string: "https://content.dailyfx.com/api/v1/dashboard") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let reports = try? JSONDecoder().decode(ReportModel.self, from: data) else {
                fatalError("Error decoding data")
            }
    
            completion(reports)
            
        }.resume()
    }
    
    /// Loads the market data
    /// - Parameter completion: market model codable  type
    func getMarketData(completion: @escaping (MarketModel)->()) {
        guard let url = URL(string: "https://content.dailyfx.com/api/v1/markets") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let marketData = try? JSONDecoder().decode(MarketModel.self, from: data) else {
                fatalError("Error decoding data")
            }
    
            completion(marketData)
            
        }.resume()
    }
}
