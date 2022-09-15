//
//  SideMenuViewController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 10/09/2022.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var sideMenuBackgroundView: UIView!
    @IBOutlet weak var searchQuotesButton: UIButton!
    @IBOutlet weak var addQuoteButton: UIButton!
    @IBOutlet weak var savedContentButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("sidemenu viewDidLoad")
    }
    
//    private func setupSideMenu() {
//        self.sideMenuBackgroundView.layer.cornerRadius = 20
//        self.sideMenuBackgroundView.clipsToBounds = true
//
//    }
}
