//
//  NetwrokInterface.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import Foundation
import UIKit

class NetworkInterface {
    
    func getImage(url: URL, completion: @escaping (UIImage)->()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                fatalError("Error decoding image data \(error!)")
            }
            
            completion(image)
        }.resume()
    }

    func getNewsList(completion: @escaping (NewsModel)->()) {
        guard let url = URL(string: "https://content.dailyfx.com/api/v1/dashboard") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let articles = try? JSONDecoder().decode(NewsModel.self, from: data) else {
                fatalError("Error decoding data")
            }
    
            completion(articles)
            
        }.resume()
    }
}
