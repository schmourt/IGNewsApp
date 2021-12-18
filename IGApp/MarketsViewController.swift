//
//  MarketsViewController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import UIKit

class MarketsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
    
                
        navigationItem.title = "Markets"
        view.backgroundColor = .green
    }
}
