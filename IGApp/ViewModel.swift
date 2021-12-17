//
//  ViewModel.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import Foundation
import UIKit

class ViewModel {
    let networkInterface = NetworkInterface()
    
    var newsDictionary = [NewsType : [SpecialReport]]()

    func getNewsList(completion: @escaping ([NewsType : [SpecialReport]])->()) {
        networkInterface.getNewsList { [weak self] news in
            
            guard let technicalAnalysis = news.technicalAnalysis,
                  let topNews = news.topNews,
                  let specialReports = news.specialReport,
                  let dailyBriefings = news.dailyBriefings,
                  let europeanReports = dailyBriefings.eu,
                  let asianReports = dailyBriefings.asia,
                  let americanReports = dailyBriefings.us else {
                return
            }
            
            self?.newsDictionary[.specialReport] = specialReports
            self?.newsDictionary[.topNews] = topNews
            self?.newsDictionary[.technicalAnalysis] = technicalAnalysis
            self?.newsDictionary[.dailyBriefings(.asia)] = asianReports
            self?.newsDictionary[.dailyBriefings(.us)] = americanReports
            self?.newsDictionary[.dailyBriefings(.eu)] = europeanReports
            
            guard let dictionary = self?.newsDictionary else {
                return
            }
            
            completion(dictionary)
        }
    }
}
