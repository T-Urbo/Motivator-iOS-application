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
import WikipediaKit
import Kingfisher

class AuthorPageViewController: ViewController {
    
    var tempURL: String = ""
    var authorName: String = ""
    var appAuthorEmail = "urbanovich.tima@gmail.com"
    var wikipedia = Wikipedia()
    var language = WikipediaLanguage("en")
    
    @IBOutlet weak var authorImage: AuthorImage!
    @IBOutlet weak var authorBioView: UIView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var birthplaceLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view was loaded")
        
        setAuthorPageView()
        setWikipediaRequestArticle()
    }
}

extension AuthorPageViewController {
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
}

extension AuthorPageViewController {
    
    func setWikipediaRequestArticle() {
        WikipediaNetworking.appAuthorEmailForAPI = appAuthorEmail
    }
    
    func setAuthorPageView() {
        self.navigationController?.title = authorName
        authorImage.layer.cornerRadius = 15
        _ = Wikipedia.shared.requestArticle(language: language, title: authorName, imageWidth: Int(authorImage.bounds.width)) { result in
            switch result {
            case .success(let article):
                self.authorImage.setImageView()
                switch article.imageURL {
                case nil:
                    self.authorImage.image = UIImage(named: "noPhotoImage")
                case .some(let url):
                    self.authorImage.kf.setImage(with: url)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
}

extension AuthorPageViewController {
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.title?.write(authorName)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
