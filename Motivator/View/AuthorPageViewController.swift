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
    var authorName: String = ""
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorInfo: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("view was loaded")
        
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        getQuoteByAuthor(authorName: authorName)
        
    }
     
    func setView() {
        self.navigationController?.title = authorName
        authorImage.layer.cornerRadius = 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotecellid", for: indexPath) as! QuoteCell
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
        
        cell.contentLabel.text = quoteViewModels[indexPath.row].quoteContent
        cell.authorButton.setTitle(quoteViewModels[indexPath.row].quoteAuthor, for: .normal)
        
        cell.tagsView.removeAllTags()
        cell.tagsView.addTags(quoteViewModels[indexPath.row].quoteTags)
        cell.authorButton.tag = indexPath.row
        cell.authorButton.addTarget(self, action: #selector(onAuthorButtonClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            getQuoteByAuthor(authorName: authorName)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
