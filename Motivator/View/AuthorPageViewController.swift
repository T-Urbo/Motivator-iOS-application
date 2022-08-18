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

// TODO: Parse and show occupation, birthplace and birthdate information
// TODO: Add author saving option
// TODO: Make shadow gradient effect between top and the tableview: DONE

class AuthorPageViewController: ViewController {
    
    var tempURL: String = ""
    var authorName: String = ""
    var authorBio = Author(_id: "", bio: "", description: "", link: "", name: "", slug: "", quoteCount: 0)
    lazy var authorUrl = "https://quotable.io/quotes?author=\(authorName.replacingOccurrences(of: " ", with: "-").lowercased())"
    var isAuthorSaved: Bool = false
    
    var appAuthorEmail = "urbanovich.tima@gmail.com"
    var language = WikipediaLanguage("en")
    
    @IBOutlet weak var authorImage: AuthorImage!
    @IBOutlet weak var authorBioView: UIView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var birthplaceLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var saveAuthorButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthorPageView()
        getQuotesByAuthor(authorName: authorName)
    }
    
    @IBAction func onSaveAuthorButtonClick(_ sender: Any) {
        print("button was tapped!!!")
        isAuthorSaved = !isAuthorSaved
        print(isAuthorSaved)
        switch isAuthorSaved {
        case true:
            if let image = UIImage(systemName: "bookmark.fill") {
                saveAuthorButton.setImage(image, for: .normal)
            }
            // do core data save to context operation
        case false:
            if let image = UIImage(systemName: "bookmark") {
                saveAuthorButton.setImage(image, for: .normal)
            }        // do core data delete from context operation
        }
    }
}

extension AuthorPageViewController {
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

extension AuthorPageViewController {
    
    func setupWikipediaRequestArticle() {
        WikipediaNetworking.appAuthorEmailForAPI = appAuthorEmail
    }
    
    func setupAuthorPageView() {
        setupWikipediaRequestArticle()
        loadAuthorBio()
        setupAuthorBio()
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
                
                switch article.imageURL {
                case nil:
                    self.authorImage.image = UIImage(named: "noPhotoImage")
                case .some(let url):
                    self.authorImage.kf.setImage(with: url)
//                    self.occupationLabel.text = author
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadAuthorBio() {
        let url = "https://quotable.io/authors?slug=" + self.authorName.replacingOccurrences(of: " ", with: "-").lowercased()
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, responce, error in
            
            guard let data = data, error == nil else { print("data is nil!"); return }
            print(data)
            
            var authorResults: AuthorResults?
            
            do {
                authorResults = try JSONDecoder().decode(AuthorResults.self, from: data)
            }
            catch {
                print(String(describing: error))
            }
            
            guard authorResults != nil else { print("authorResults is nil!"); return }
            self.authorBio = authorResults!.results.first!
            print("authorBio after loadAfterBio func: \(self.authorBio)")
            DispatchQueue.main.async {
                self.occupationLabel.text = self.authorBio.description
                guard let firstIndexOfDate = self.authorBio.bio.firstIndex(of: "(") else { self.birthDateLabel.text = ""; return }
                guard let lastIndexOfDate = self.authorBio.bio.firstIndex(of: ")") else { return }
                //range requires upper/lower bound
                let range = firstIndexOfDate ..< lastIndexOfDate
                let lifetime = self.authorBio.bio
                self.birthDateLabel.text = String(lifetime[range]).replacingOccurrences(of: "(", with: "")
            }
        })
        task.resume()
    }
    
    func getQuotesByAuthor(authorName name: String)  {

        let url = "https://quotable.io/quotes?author=" + name.replacingOccurrences(of: " ", with: "-").lowercased()


        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in

            guard let data = data, error == nil else {
                print("JSON Parsing error!")
                return
            }

            var quoteByAuthor: QuoteByAuthor?

            do {
                quoteByAuthor = try JSONDecoder().decode(QuoteByAuthor.self, from: data)
            }
            catch {
                print(String(describing: error))
            }

            guard quoteByAuthor != nil else {
                return
            }

            for i in 0...(quoteByAuthor?.results.count)! - 1 {
                let quoteViewModel = QuoteModel(quote: (quoteByAuthor?.results[i])!)
                self.quoteViewModel.quotes.append(quoteViewModel)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        task.resume()
    }
    
    func setupAuthorBio() {
        self.occupationLabel.text = ""
        self.birthplaceLabel.text = ""
    }
    
    
}

extension AuthorPageViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewwillappear")
        print(authorBio)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
//            getQuotesByAuthor(authorName: authorName)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
    }
}
