//
//  SideMenuController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 10/09/2022.
//

import UIKit

class SideMenuController: UIViewController {

    struct MenuItem {
        var itemName: String
        var segueID: String
    }
    
    var menuItems: [MenuItem] = [
        MenuItem(itemName: "Search quotes", segueID: "search_quotes_segue"),
        MenuItem(itemName: "Add quote", segueID: "add_quote_segue"),
        MenuItem(itemName: "Saved quotes", segueID: "saved_quotes_segue")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
