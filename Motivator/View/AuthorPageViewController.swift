//
//  AuthorPageViewController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 13/07/2022.
//

import UIKit
import Foundation
import RxSwift
import TagListView


class AuthorPageViewController: ViewController {
    
    var tempURL: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        url = tempURL
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getQuoteByAuthor(from: url)
        print("view was loaded")
        
        
    }
}
