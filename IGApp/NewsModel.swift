//
//  NewsModel.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import Foundation

// MARK: - NewsModel
struct NewsModel: Codable {
    let topNews: [SpecialReport]?
    let dailyBriefings: DailyBriefings?
    let technicalAnalysis, specialReport: [SpecialReport]?
}

// MARK: - DailyBriefings
struct DailyBriefings: Codable {
    let eu, asia, us: [SpecialReport]?
}

// MARK: - SpecialReport
struct SpecialReport: Codable {
    let title: String?
    let url: String?
    let specialReportDescription: String?
    let headlineImageURL: String?
    let newsKeywords: String?
    let authors: [[String: String?]]?
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

// MARK: - NewsType Enum
enum NewsType: Hashable {
    case topNews,
         specialReport,
         technicalAnalysis,
         dailyBriefings(DailyBriefingCountry)
    
    var section: Int {
        switch self {
        case .topNews:
            return 0
        case .specialReport:
            return 1
        case .technicalAnalysis:
            return 2
        case .dailyBriefings(_):
            return 3
        }
    }
    
    var name: String {
        switch self {
        case .topNews:
            return "Top News"
        case .specialReport:
            return "Special Report"
        case .technicalAnalysis:
            return "Technical Analysis"
        case .dailyBriefings(_):
            return "Daily Briefings"
        }
    }
}

// MARK: - DailyBriefingCountry Enum
enum DailyBriefingCountry: Int {
    case eu,
         asia,
         us
    
    var name: String {
        switch self {
        case .eu:
            return "Europe"
        case .asia:
            return "Asia"
        case .us:
            return "United States"
        }
    }
}
