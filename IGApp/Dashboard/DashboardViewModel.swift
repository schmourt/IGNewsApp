//
//  ViewModel.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import UIKit

class DashboardViewModel {
    let networkInterface = NetworkInterface()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "h:mm a, dd MMMM YYYY"
        return formatter
    }()
    
    var reportDictionary = [ReportType : [Report]]()
    
    func getImageForURL(urlString: String, completion: @escaping (UIImage)->()) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        networkInterface.getImage(url: url) { image in
            completion(image)
        }
    }

    func getNewsList(completion: @escaping ()->()) {
        
        networkInterface.getNewsList { [weak self] news in
            
            var dictionary = [ReportType : [Report]]()
            
            guard let technicalAnalysis = news.technicalAnalysis,
                  let topNews = news.topNews,
                  let specialReports = news.specialReport,
                  let dailyBriefings = news.dailyBriefings,
                  let europeanReports = dailyBriefings.eu,
                  let asianReports = dailyBriefings.asia,
                  let americanReports = dailyBriefings.us else {
                return
            }
            
            dictionary[.topNews] = self?.makeNewsReport(reports: topNews)
            dictionary[.specialReport] = self?.makeNewsReport(reports: specialReports)
            dictionary[.dailyBriefingsEU] = self?.makeNewsReport(reports: europeanReports)
            dictionary[.dailyBriefingsAsia] = self?.makeNewsReport(reports: asianReports)
            dictionary[.dailyBriefingsUS] = self?.makeNewsReport(reports: americanReports)
            dictionary[.technicalAnalysis] = self?.makeNewsReport(reports: technicalAnalysis)
            
            self?.reportDictionary = dictionary
            completion()
        }
    }
    
    private func convertDate(dateInt: Int) -> String {
        let truncatedTime = Int(dateInt / 1000)
        let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))
        
        return formatter.string(from: date)
    }
    
    private func makeNewsReport(reports: [NetworkReport]) -> [Report] {
        var newsReports = [Report]()
        
        for report in reports {
            let title = report.title ?? "Title Unavailable"
            let authors = report.authors ?? [Authors(name: "N/A", title: "N/A", photo: "N/A")]
            let description = report.specialReportDescription ?? "Description Unavailable"
            let authorImageURL = authors[0].photo ?? "N/A"
            let timestamp = report.displayTimestamp ?? 0
            let updatedTimestamp = report.lastUpdatedTimestamp ?? 0
            let imageURL = report.headlineImageURL ?? "N/A"
            let url = report.url ?? "N/A"
                
            
            let authorNames = authors.map {$0.name ?? ""}.joined(separator: ", ")
            
            newsReports.append(Report(title: title, description: description, authors: authorNames, authorImageURL: authorImageURL, timestamp: convertDate(dateInt: timestamp), updatedTimestamp: convertDate(dateInt: updatedTimestamp), reportImageURL: imageURL, url: url))
        }
        return newsReports
    }
}
