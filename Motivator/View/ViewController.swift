//
//  ViewController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 07/07/2022.
//

//TODO: Choose frameworks -> RxSwift, RxCocoa
//      Decide about the architecture -> MVVM
//      Find an API source of quotes: quotable.io



import UIKit
import RxSwift
import TagListView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var quoteController = QuoteController()
    var quoteViewModels = [QuoteViewModel]()
    var tempTagsArray = [String]()
    
    var url: String = "https://api.quotable.io/random"
    let cellId = "quotecellid"
    let nib = UINib(nibName: "QuoteCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
        
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        getRandomQuote(from: url)
        
    }
}

extension ViewController {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotecellid", for: indexPath) as! QuoteCell
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
        
        cell.contentLabel.text = quoteViewModels[indexPath.row].quoteContent
        cell.authorLabel.text = quoteViewModels[indexPath.row].quoteAuthor
        
        // Problem is in here //
        cell.tagsView.removeAllTags()
        cell.tagsView.addTags(quoteViewModels[indexPath.row].quoteTags)
        
       
        return cell
    }
    
    // Get data from an API
    
    func getRandomQuote(from url: String?) {
        
        assert(url != nil, "URL isn't correct")
        
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("JSON Parsing error!")
                return
            }
            
            var quote: Quote?
            
            do {
                quote = try JSONDecoder().decode(Quote.self, from: data)
            }
            catch {
                print(String(describing: error))
            }
            
            guard quote != nil else {
                return
            }
            
            let quoteViewModel = QuoteViewModel(quote: quote!)
            self.quoteViewModels.append(quoteViewModel)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            
            print(quoteViewModel.quoteTags)
            
        })
        task.resume()
        
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.backgroundColor = .systemBlue
    }
    
    func setupTableView() {
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func getUniqueElements(from array: [String]) -> [String] {
      //Create an empty Set to track unique items
      var set = Set<String>()
      let result = array.filter {
        guard !set.contains($0) else {
          //If the set already contains this object, return false
          //so we skip it
          return false
        }
        //Add this item to the set since it will now be in the array
        set.insert($0)
        //Return true so that filtered array will contain this item.
        return true
      }
      return result
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
//            print("getch more data")
            getRandomQuote(from: url)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}