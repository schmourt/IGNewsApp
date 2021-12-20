//
//  ReportCellViewModel.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/20/21.
//

import UIKit

// MARK: - Report to easily handle in UI
struct ReportCellViewModel {
    private let networkInterface = NetworkInterface()

    let title: String
    let description: String
    let authors: String
    let authorImageURL: String
    let timestamp: String
    let updatedTimestamp: String
    let reportImageURL: String
    let url: String

    /// Get an image from network layer to use in UI
    /// - Parameters:
    ///   - urlString: url used for image
    ///   - completion: pass the image
    func getImageForURL(urlString: String, completion: @escaping (UIImage)->()) {
        guard let url = URL(string: urlString) else {
            return
        }

        networkInterface.getImage(url: url) { image in
            completion(image)
        }
    }
}
