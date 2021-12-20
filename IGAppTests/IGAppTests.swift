//
//  IGAppTests.swift
//  IGAppTests
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import XCTest
@testable import IGApp

class IGAppTests: XCTestCase {
    
    private func getReports() -> ReportModel {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "dashboard", ofType: "json"),
              let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8),
              let jsonData = jsonString.data(using: .utf8),
              let reports = try? JSONDecoder().decode(ReportModel.self, from: jsonData) else {
            fatalError("dashboard.json error parsing")
        }
        return reports
    }

    private func setUpMarkets() -> MarketModel {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "markets", ofType: "json"),
              let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8),
              let jsonData = jsonString.data(using: .utf8),
              let markets = try? JSONDecoder().decode(MarketModel.self, from: jsonData) else {
            fatalError("dashboard.json error parsing")
        }
        return markets
    }
    
    func testDashboardViewModel() {
        let reports = getReports()
        
        let viewModel = DashboardViewModel()
        
        viewModel.formatReports(reports: reports)
        
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsEU]?.count, 1)
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsAsia]?.count, 1)
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsUS]?.count, 1)
        XCTAssertEqual(viewModel.reportDictionary[.technicalAnalysis]?.count, 5)
        XCTAssertEqual(viewModel.reportDictionary[.topNews]?.count, 3)
        
        XCTAssertEqual(viewModel.reportDictionary[.topNews]?[0].timestamp,
                       "12:40 AM, 19 December 2021")
        XCTAssertEqual(viewModel.reportDictionary[.technicalAnalysis]?[0].timestamp,
                       "6:00 AM, 18 December 2021")
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsEU]?[0].authors,
                       "Christopher Vecchio, CFA")
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsAsia]?[0].description,
                       "The Euro has been trading in a narrowing range against the US Dollar as the market awaits a plethora of central bank meetings this week. Where to for EUR/USD?")
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsUS]?[0].updatedTimestamp,
                       "3:05 PM, 16 December 2021")
        XCTAssertEqual(viewModel.reportDictionary[.topNews]?[0].title,
                       "7 Step Trading Checklist Before Entering Any Trade")
        XCTAssertEqual(viewModel.reportDictionary[.technicalAnalysis]?[0].authorImageURL,
                       "https://a.c-dn.net/b/1lGC9B.png#Warren%20Venketas.png")
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsEU]?[0].reportImageURL,
                       "https://a.c-dn.net/b/1orksJ/headline_262576440_1-7.jpg")
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsAsia]?[0].authors,
                       "Daniel McCarthy")
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsUS]?[0].title,
                       "Euro, Pound Technical Analysis: EUR/USD, GBP/USD, GBP/JPY")
        XCTAssertEqual(viewModel.reportDictionary[.topNews]?[0].updatedTimestamp,
                       "12:41 AM, 19 December 2021")
        XCTAssertEqual(viewModel.reportDictionary[.technicalAnalysis]?[2].timestamp,
                       "12:00 AM, 18 December 2021")
        XCTAssertEqual(viewModel.reportDictionary[.dailyBriefingsEU]?[0].description,
                       "The Euro remains plagued the by the pandemic, as slowed growth and high inflation leave the ECB in a bind.")
    }
    
    func testDashboardViewController() {
        let tableViewController = DashboardTableViewController()
        let reports = getReports()
    
        tableViewController.viewModel.formatReports(reports: reports)
        tableViewController.loadViewIfNeeded()
        
        let tableView = tableViewController.tableView!
        tableView.reloadData()
        tableView.reloadInputViews()
        
        XCTAssertEqual(tableView.numberOfSections, 6)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 3)
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)).textLabel?.text,
                       "Euro Forecast: More Downside Looks Likely for EUR/GBP, EUR/JPY, EUR/USD")
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)).detailTextLabel?.text,
                       "\nThe Euro remains plagued the by the pandemic, as slowed growth and high inflation leave the ECB in a bind.\n\nChristopher Vecchio, CFA\n7:30 PM, 09 December 2021")
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 1)).textLabel?.text,
                       "A Guide to Trading Psychology")
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 1)).detailTextLabel?.text,
                       "\nHawkish and dovish policies affect FX rates through a mechanism referred to as \'forward guidance\'.\n\nDavid Bradfield\n2:00 AM, 18 December 2021")
    }
    
    func testReportDetailViewController() {
        let mockReport = Report(title: "Title", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", authors: "Arthur Author", authorImageURL: "https://www.website.com/image.jpeg", timestamp: "4:00 PM 25 December 2022", updatedTimestamp: "5:00 PM 25 December 2022", reportImageURL: "https://www.website.com/image.jpeg", url: "https://www.website.com")
        
        let reportViewController = ReportDetailViewController(report: mockReport)
        
        reportViewController.loadView()
        
        XCTAssertEqual(reportViewController.titleLabel.text!, "Title")
        XCTAssertEqual(reportViewController.descriptionLabel.text!,
                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
        XCTAssertEqual(reportViewController.authorLabel.text!, "Written by: Arthur Author")
        XCTAssertEqual(reportViewController.timestampLabel.text!, "Last updated: 5:00 PM 25 December 2022")
        XCTAssertEqual(reportViewController.viewOnWebButton.titleLabel?.text!, "Tap to view on web")
    }
    
    func testMarketsViewModel() {
        let marketData = setUpMarkets()
        let viewModel = MarketsViewModel()
        
        viewModel.formatMarketData(data: marketData)
        
        XCTAssertEqual(viewModel.marketDictionary[.currencies]?.count, 42)
        XCTAssertEqual(viewModel.marketDictionary[.commodities]?.count, 6)
        XCTAssertEqual(viewModel.marketDictionary[.indices]?.count, 13)
        
        XCTAssertEqual(viewModel.marketDictionary[.indices]?[0].displayName, "USDOLLAR")
        XCTAssertEqual(viewModel.marketDictionary[.commodities]?[1].marketID, "SI")
        XCTAssertEqual(viewModel.marketDictionary[.indices]?[2].rateDetailURL,
                       "https://www.dailyfx.com/dow-jones")
        XCTAssertEqual(viewModel.marketDictionary[.currencies]?[4].marketID, "USDCAD")
        XCTAssertEqual(viewModel.marketDictionary[.indices]?[5].displayName, "FTSE 100")
        XCTAssertEqual(viewModel.marketDictionary[.commodities]?[2].rateDetailURL, "https://www.dailyfx.com/crude-oil")
        XCTAssertEqual(viewModel.marketDictionary[.indices]?[4].displayName,
                       "Germany 30")
        XCTAssertEqual(viewModel.marketDictionary[.currencies]?[3].rateDetailURL, "https://www.dailyfx.com/aud-usd")
    }
    
    func testMarketsTableViewController() {
        let tableViewController = MarketsTableViewController()
        let marketData = setUpMarkets()
    
        tableViewController.viewModel.formatMarketData(data: marketData)
        tableViewController.loadViewIfNeeded()
        
        let tableView = tableViewController.tableView!
        tableView.reloadData()
        tableView.reloadInputViews()
        
        XCTAssertEqual(tableView.numberOfSections, 3)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 42)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 6)
        XCTAssertEqual(tableView.numberOfRows(inSection: 2), 13)
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)).textLabel?.text, "USDOLLAR")
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)).detailTextLabel?.text, "DX")
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 5, section: 1)).textLabel?.text, "Natural Gas")
        XCTAssertEqual(tableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)).detailTextLabel?.text, "USDJPY")
    }
}
