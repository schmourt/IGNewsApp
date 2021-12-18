//
//  NewsModel.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import Foundation

// MARK: - ReportModel
struct ReportModel: Codable {
    let topNews: [NetworkReport]?
    let dailyBriefings: DailyBriefings?
    let technicalAnalysis, specialReport: [NetworkReport]?
}

// MARK: - DailyBriefings
struct DailyBriefings: Codable {
    let eu, asia, us: [NetworkReport]?
}

// MARK: - NetworkReport
struct NetworkReport: Codable {
    let title: String? 
    let url: String?
    let specialReportDescription: String?
    let headlineImageURL: String?
    let newsKeywords: String?
    let authors: [Authors]?
    let instruments: [String]?
    let tags: [String]?
    let categories: [String]?
    let displayTimestamp, lastUpdatedTimestamp: Int?

    enum CodingKeys: String, CodingKey {
        case specialReportDescription = "description"
        case headlineImageURL = "headlineImageUrl"
        case title, url, newsKeywords, authors, instruments, tags, categories, displayTimestamp, lastUpdatedTimestamp
    }
}

// MARK: - Authors
struct Authors: Codable {
    let name: String?
    let title: String?
    let photo: String?
    
    enum CodingKeys: String, CodingKey {
        case name, title, photo
    }
}

// MARK: - ReportType Enum
enum ReportType: Int, Hashable {
    case topNews,
        specialReport,
        dailyBriefingsEU,
        dailyBriefingsAsia,
        dailyBriefingsUS,
        technicalAnalysis
    
    var name: String {
        switch self {
        case .topNews:
            return "Top News"
        case .specialReport:
            return "Special Report"
        case .dailyBriefingsEU:
            return "Europe"
        case .dailyBriefingsAsia:
            return "Asia"
        case .dailyBriefingsUS:
            return "United States"
        case .technicalAnalysis:
            return "Technical Analysis"
        }
    }
}

// MARK: - Report to easily handle in UI
struct Report {
    let title: String
    let description: String
    let authors: String
    let authorImageURL: String
    let timestamp: String
    let updatedTimestamp: String
    let reportImageURL: String
    let url: String
}
