//
//  DashboardViewModel.swift
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
    
    var reportDictionary = [ReportType : [ReportCellViewModel]]()

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
        var dictionary = [ReportType : [ReportCellViewModel]]()
        
        guard let technicalAnalysis = reports.technicalAnalysis,
              let topNews = reports.topNews,
              let specialReports = reports.specialReport,
              let dailyBriefings = reports.dailyBriefings,
              let europeanReports = dailyBriefings.eu,
              let asianReports = dailyBriefings.asia,
              let americanReports = dailyBriefings.us else {
            return
        }
        
        dictionary[.topNews] = makeReportViewModels(reports: topNews)
        dictionary[.specialReport] = makeReportViewModels(reports: specialReports)
        dictionary[.dailyBriefingsEU] = makeReportViewModels(reports: europeanReports)
        dictionary[.dailyBriefingsAsia] = makeReportViewModels(reports: asianReports)
        dictionary[.dailyBriefingsUS] = makeReportViewModels(reports: americanReports)
        dictionary[.technicalAnalysis] = makeReportViewModels(reports: technicalAnalysis)
        
        reportDictionary = dictionary
    }
    
    /// Converts the network struct report type into a report type used for UI
    /// - Parameter reports: network report to be converted
    /// - Returns: array of reports ready for UI
    private func makeReportViewModels(reports: [NetworkReport]) -> [ReportCellViewModel] {
        var newsReports = [ReportCellViewModel]()
        
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
            
            newsReports.append(ReportCellViewModel(title: title, description: description, authors: authorNames, authorImageURL: authorImageURL, timestamp: convertDate(dateInt: timestamp), updatedTimestamp: convertDate(dateInt: updatedTimestamp), reportImageURL: imageURL, url: url))
        }
        return newsReports
    }

    /// Converts int into timestamp
    /// - Parameter dateInt: 13-digit integer value such as 1639874482891
    /// - Returns: String format such as "10:00 AM, 23 February 2022"
    private func convertDate(dateInt: Int) -> String {
        let truncatedTime = Int(dateInt / 1000)
        let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))

        return formatter.string(from: date)
    }

    func getNumberOfRowsInSection(section: Int) -> Int {
        guard let reportType = ReportType(rawValue: section), let reports = reportDictionary[reportType] else {
            return 0
        }

        return reports.count
    }

    func getTitleForSection(section: Int) -> String {
        guard let reportType = ReportType(rawValue: section) else {
            return ""
        }

        return reportType.name.uppercased()
    }

    func getReport(for indexPath: IndexPath) -> ReportCellViewModel? {
        guard let reportType = ReportType(rawValue: indexPath.section),
              let reports = reportDictionary[reportType] else {
                  return nil
              }

        return reports[indexPath.row]
    }

    func getNumberOfSections() -> Int {
        return reportDictionary.keys.count
    }
}
