////
////  TagsPageViewController.swift
////  Motivator
////
////  Created by Timothey Urbanovich on 26/08/2022.
////
//
//import UIKit
//import Foundation
//import RxSwift
//import TagListView
//import WikipediaKit
//import Kingfisher
//
//class TagsPageViewController: ViewController {
//    
//    @IBOutlet weak var tagsLabel: UILabel!
//    
//    var tag: String = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print("tagspageview was loaded")
//        
//        setupTagsPageVC()
//        self.quoteViewModel.getQuotesByTag(tagName: self.tag, completionHandler: { (quote, error) in
//            if(quote != nil) {
//                DispatchQueue.main.async {
//                    print("tagspagevc dispatchqueuemainasync")
//                    self.tableView.reloadData()
//                }
//            }
//        })
//    }
//
//    func setupTagsPageVC() {
//        tagsLabel.textWithAnimation(text: "Quotes for tag: #\(tag)", duration: 0.3)
//    }
//    
//    
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//// MARK: - TagsPageViewController's table view data source
//extension TagsPageViewController {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.quoteViewModel.quotes.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCellViewModelid", for: indexPath) as! QuoteCellViewModel
//        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
//        cell.layoutIfNeeded()
//        
//        cell.contentLabel.text = quoteViewModel.quotes[indexPath.row].quoteContent
//        cell.authorButton.setTitle(quoteViewModel.quotes[indexPath.row].quoteAuthor, for: .normal)
//        
//        cell.tagsView.removeAllTags()
//        cell.tagsView.addTags(quoteViewModel.quotes[indexPath.row].quoteTags)
//        cell.authorButton.tag = indexPath.row
//        cell.authorButton.addTarget(self, action: #selector(onAuthorButtonClick(_:)), for: .touchUpInside)
//        
//        return cell
//    }
//}
