//
//  ViewController.swift
//  IGApp
//
//  Created by Courtney Langmeyer on 12/16/21.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.getNewsList { [weak self] dictionary in
            print("special reports", dictionary[.specialReport]?.count)
            print(dictionary[.dailyBriefings(.us)]?[0].title)
        }
        
    }


}

