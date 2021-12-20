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
    
    /// Get the reports  from the API layer and populate the dictionary for the tableview
    /// - Parameter completion: notifies the tableview that the dictionary has loaded
    func getReports(completion: @escaping ()->()) {
        networkInterface.getReports { [weak self] reports in
            self?.formatReports(reports: reports)
            completion()
        }
    }
    
    /// Format the network reponse into a dictionary of reports and their types
    /// - Parameter reports: netwrok report type
    func formatReports(reports: ReportModel) {
        var dictionary = [ReportType : [Report]]()
        
        guard let technicalAnalysis = reports.technicalAnalysis,
              let topNews = reports.topNews,
              let specialReports = reports.specialReport,
              let dailyBriefings = reports.dailyBriefings,
              let europeanReports = dailyBriefings.eu,
              let asianReports = dailyBriefings.asia,
              let americanReports = dailyBriefings.us else {
            return
        }
        
        dictionary[.topNews] = makeNewsReport(reports: topNews)
        dictionary[.specialReport] = makeNewsReport(reports: specialReports)
        dictionary[.dailyBriefingsEU] = makeNewsReport(reports: europeanReports)
        dictionary[.dailyBriefingsAsia] = makeNewsReport(reports: asianReports)
        dictionary[.dailyBriefingsUS] = makeNewsReport(reports: americanReports)
        dictionary[.technicalAnalysis] = makeNewsReport(reports: technicalAnalysis)
        
        reportDictionary = dictionary
    }
    
    /// Converts int into timestamp
    /// - Parameter dateInt: 13-digit integer value such as 1639874482891
    /// - Returns: String format such as "10:00 AM, 23 February 2022"
    private func convertDate(dateInt: Int) -> String {
        let truncatedTime = Int(dateInt / 1000)
        let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))
        
        return formatter.string(from: date)
    }
    
    /// Converts the network struct report type into a report type used for UI
    /// - Parameter reports: network report to be converted
    /// - Returns: array of reports ready for UI
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
