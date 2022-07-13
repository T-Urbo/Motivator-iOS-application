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
    
    var url: String = "https://api.quotable.io/random?tags=technology,famous-quotes"
//    var url: String = "https://quotable.io/quotes?page=1"
    let cellId = "quotecellid"
    let nib = UINib(nibName: "QuoteCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        tableView.register(nib, forCellReuseIdentifier: cellId)
        getData(from: url)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
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
        quoteViewModels[indexPath.row].quoteTags.forEach() { tags in
            cell.tagsView.addTag(tags)
        }
        
        return cell
    }
    
    // Get data from an API
    
    func getData(from url: String?) {
        
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
            
        })
        task.resume()
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.backgroundColor = .systemBlue
    }
    
    
}
