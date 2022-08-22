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
    
// TODO: Add author saving option
// TODO: Add author's name on top of the view
    
protocol SaveAuthorDelegate {
    func saveAuthor(authorName: String)
}

class AuthorPageViewController: ViewController {
    
    var tempURL: String = ""
    var authorName: String = ""
    
    lazy var authorUrl = "https://quotable.io/quotes?author=\(authorName.replacingOccurrences(of: " ", with: "-").lowercased())"
    var isAuthorSaved: Bool = false
    
    
    var appAuthorEmail = "urbanovich.tima@gmail.com"
    var language = WikipediaLanguage("en")
    
    @IBOutlet weak var authorImage: AuthorImage!
    @IBOutlet weak var authorBioView: UIView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var saveAuthorButton: UIButton!
    
    var authorViewModel = AuthorViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthorPageView()
        quoteViewModel.quotes.removeAll()
        quoteViewModel.getQuotesByAuthor(authorName: authorName, completionHandler: { (quote, error) in
            if(quote != nil) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func onSaveAuthorButtonClick(_ sender: Any) {
        print("button was tapped!!!")
        print(isAuthorSaved)
        switch isAuthorSaved {
        case true:
            if let image = UIImage(systemName: "bookmark.fill") {
                saveAuthorButton.setImage(image, for: .normal)
            }
            if(!super.savedAuthorsArray.contains(authorViewModel.author)) {
                super.savedAuthorsArray.append(authorViewModel.author)
                print("SavedAuthorsArray: \(super.savedAuthorsArray)")
                print("savedAuthors: \(super.savedAuthorsArray.count)")
            }
            // do core data save operation
        case false:
            if let image = UIImage(systemName: "bookmark") {
                saveAuthorButton.setImage(image, for: .normal)
            }
            
            if(super.savedAuthorsArray.contains(authorViewModel.author)) {
                if let authorToRemoveIndex = super.savedAuthorsArray.index(of: authorViewModel.author) {
                    super.savedAuthorsArray.remove(at: authorToRemoveIndex)
                    print("SavedAuthorsArray: \(super.savedAuthorsArray)")
                    print("savedAuthors: \(super.savedAuthorsArray.count)")
                }
            }
            // do core data delete from context operation
        }
        isAuthorSaved = !isAuthorSaved
    }
}

// MARK: - AuthorPageViewController table view data source

extension AuthorPageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorViewModel.author.quoteCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotecellid", for: indexPath) as! QuoteCell
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
        
        cell.contentLabel.text = quoteViewModel.quotes[indexPath.row].quoteContent
        cell.authorButton.setTitle(quoteViewModel.quotes[indexPath.row].quoteAuthor, for: .normal)
        
        cell.tagsView.removeAllTags()
        cell.tagsView.addTags(quoteViewModel.quotes[indexPath.row].quoteTags)
        cell.authorButton.tag = indexPath.row
        cell.authorButton.addTarget(self, action: #selector(onAuthorButtonClick(_:)), for: .touchUpInside)
        
        // cell.authorButton - try to disable the author button
        
        return cell
    }
}

// MARK: - AuthorPageViewController setup

extension AuthorPageViewController {
    func setupWikipediaRequestArticle() {
        WikipediaNetworking.appAuthorEmailForAPI = appAuthorEmail
    }
    
    func setupAuthorPageView() {
        setupWikipediaRequestArticle()
        authorViewModel.loadAuthorBio(authorName: authorName)

        authorBioView.layer.masksToBounds = false
        authorBioView.layer.shadowRadius = 4
        authorBioView.layer.shadowOpacity = 1
        authorBioView.layer.shadowColor = UIColor.gray.cgColor
        authorBioView.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveAuthorButton.isEnabled = true
        
        self.navigationController?.title = authorName
        authorImage.layer.cornerRadius = 15
        _ = Wikipedia.shared.requestArticle(language: language, title: authorName, imageWidth: Int(authorImage.bounds.width)) { result in
            switch result {
            case .success(let article):
                self.authorImage.setImageView()
                self.setupAuthorBio(withAuthor: self.authorViewModel)
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

    
    
    func setupAuthorBio(withAuthor author: AuthorViewModel) {
        
        self.occupationLabel.text = author.author.description + " •"
        self.birthDateLabel.text = {
            guard let firstIndexDate = author.author.bio.firstIndex(of: "(") else { return "Unknown"}
            guard let lastIndexDate = author.author.bio.firstIndex(of: ")") else { return "Unknown"}
            return String(author.author.bio[firstIndexDate..<lastIndexDate]).replacingOccurrences(of: "(", with: "") + " •"
        }()
    }
}
//
//extension AuthorPageViewController {
//
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
//            authorViewModel.getQuotesByAuthor(authorName: authorName)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//}
