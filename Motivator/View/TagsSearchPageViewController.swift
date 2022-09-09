//
//  TagsPageViewController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 26/08/2022.
//

import UIKit
import Foundation
//import RxSwift
import TagListView
import WikipediaKit
import Kingfisher

class TagsSearchPageViewController: ViewController {
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var tagsSearchPageTableView: UITableView!
//    let nib = UINib(nibName: "QuoteCell", bundle: nil)
//    let cellId = "quotecellid"
    
//    var quoteViewModel = QuoteViewModel()
    
    var tag: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupTableView()
        setupTagsPageVC()
        
        print("tagspageview was loaded")
        
        self.quoteViewModel.quotes.removeAll()
        self.quoteViewModel.getQuotesByTag(tagName: tag, completionHandler: { (quote, error) in
            if(quote != nil) {
                print(self.quoteViewModel.quotes.count)
                DispatchQueue.main.async {
                    print("tagspagevc dispatchqueuemainasync")
                    self.tableView.reloadData()
                }
            } else {
                print("quote isnt a nil!")
            }
        })
        
        
    }
    
//    func setupTableView() {
//        tagsSearchPageTableView.register(nib, forCellReuseIdentifier: cellId)
//        tagsSearchPageTableView.dataSource = self
//        tagsSearchPageTableView.delegate = self
//        tagsSearchPageTableView.rowHeight = UITableView.automaticDimension
//        tagsSearchPageTableView.showsVerticalScrollIndicator = false
//    }
    
//    @objc func onAuthorButtonClick(_ button: UIButton) {
//        print("the button with tag: \(button.tag) clicked in cell!")
//        if let authorpagevc = storyboard?.instantiateViewController(identifier: "apvc") as? AuthorPageViewController {
//            authorpagevc.authorName = (button.titleLabel?.text!)!
//            authorpagevc.title = (button.titleLabel?.text!)!
//            self.present(authorpagevc, animated: true, completion: nil)
//        }
//        DispatchQueue.main.async {
//            self.tagsSearchPageTableView.reloadData()
//        }
//    }

    func setupTagsPageVC() {
        tagsLabel.textWithAnimation(text: "Quotes for tag: #\(tag)", duration: 0.3)
    }
}

// MARK: - TagsPageViewController's table view data source
//extension TagsSearchPageViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.quoteViewModel.quotes.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "quotecellid", for: indexPath) as! QuoteCell
//        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
//        cell.layoutIfNeeded()
//
//        cell.tagsView.delegate = self
//
//        cell.contentLabel.text = quoteViewModel.quotes[indexPath.row].quoteContent
//
//        cell.authorButton.setTitle(quoteViewModel.quotes[indexPath.row].quoteAuthor, for: .normal)
//        cell.authorButton.tag = indexPath.row
//        cell.authorButton.addTarget(self, action: #selector(onAuthorButtonClick(_:)), for: .touchUpInside)
//
//        cell.tagsView.removeAllTags()
//        cell.tagsView.addTags(quoteViewModel.quotes[indexPath.row].quoteTags)
//        cell.tagsView.delegate = self
//
//        return cell
//    }
//}
