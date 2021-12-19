//
//  TabBarController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        delegate = self
    }
}

// MARK: - TabBarController Delegates
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
