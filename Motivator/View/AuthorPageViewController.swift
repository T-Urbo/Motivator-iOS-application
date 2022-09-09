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
    
// TODO: - Add author saving option
// TODO: - Add author's name on top of the view
// TODO: - Add label text changing animation
// TODO: - Fix displaying authorsBio bug (second tap on author's button shows only 2 dots even if data exists)
    
protocol SaveAuthorDelegate {
    func saveAuthor(authorName: String)
}

class AuthorPageViewController: ViewController {
    
    var tempURL: String = ""
    var authorName: String = ""
    lazy var authorUrl = "https://quotable.io/quotes?author=\(authorName.replacingOccurrences(of: " ", with: "-").lowercased())"
    var isAuthorSaved: Bool = false
    var appAuthorEmail = "urbanovich.tima@gmail.com"
   
    
//    var authorModel = AuthorModel(withAuthor: AuthorViewModel.author)
    var authorViewModel = AuthorViewModel()
    
    @IBOutlet weak var authorImage: AuthorImage!
    @IBOutlet weak var authorBioView: UIView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var saveAuthorButton: UIButton!
    
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
    
    // MARK: - Saving author function
    
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
            // do core data delete from context operation
        }
        isAuthorSaved = !isAuthorSaved
    }
}

    // MARK: - AuthorPageViewController's table view data source

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
        setupAuthorBio(withAuthor: authorViewModel)
        authorBioView.layer.masksToBounds = false
        authorBioView.layer.shadowRadius = 4
        authorBioView.layer.shadowOpacity = 1
        authorBioView.layer.shadowColor = UIColor.gray.cgColor
        authorBioView.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveAuthorButton.isEnabled = true
        
        self.navigationController?.title = authorName
        authorImage.layer.cornerRadius = 15
        let language = WikipediaLanguage("en")
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
        author.loadAuthorBio(authorName: authorName)
        
        print("SUCCESS loading author's bio!")
        self.occupationLabel.textWithAnimation(text: author.author.description + " •", duration: 0.25)
        self.birthDateLabel.textWithAnimation(text: {
            guard let firstIndexDate = author.author.bio.firstIndex(of: "(") else { return ""}
            guard let lastIndexDate = author.author.bio.firstIndex(of: ")") else { return ""}
            return String(author.author.bio[firstIndexDate..<lastIndexDate]).replacingOccurrences(of: "(", with: "")
        }() + " •", duration: 0.25)
    }
}

extension UIView {
    func makeFadeTransition(inTime duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UILabel{

  func animation(typing value:String,duration: Double){
    let characters = value.map { $0 }
    var index = 0
    Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] timer in
        if index < value.count {
            let char = characters[index]
            self?.text! += "\(char)"
            index += 1
        } else {
            timer.invalidate()
        }
    })
  }

  func textWithAnimation(text:String,duration:CFTimeInterval){
    fadeTransition(duration)
    self.text = text
  }

  func fadeTransition(_ duration:CFTimeInterval) {
    let animation = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name:
        CAMediaTimingFunctionName.easeInEaseOut)
    animation.type = CATransitionType.fade
    animation.duration = duration
    layer.add(animation, forKey: CATransitionType.fade.rawValue)
  }

}
