//
//  QuoteController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 12/07/2022.
//

import UIKit

class QuoteController: UITableViewController {
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return quoteViewModels.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "quotecell", for: indexPath)
//        
//        cell.textLabel?.text = quoteViewModels[indexPath.row].quoteAuthor
//        cell.detailTextLabel?.text = quoteViewModels[indexPath.row].quoteContent
//        
//        return cell
//    }
//    
//    // Get data from an API
//    
//    func getData(from url: String?) {
//        
//        assert(url != nil, "URL isn't correct")
//        guard let url = url else {
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
//            
//            guard let data = data, error == nil else {
//                print("JSON Parsing error!")
//                return
//            }
//            
//            var quote: Quote?
//            
//            do {
//                quote = try JSONDecoder().decode(Quote.self, from: data)
//            }
//            catch {
//                print(String(describing: error))
//            }
//            
//            guard quote != nil else {
//                return
//            }
//            
//            let quoteViewModel = QuoteViewModel(quote: quote!)
//            self.quoteViewModels.append(quoteViewModel)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//            
//        })
//        task.resume()
//    }
//    
//    func setupTableView() {
//        tableView.register(QuoteCell.self, forCellReuseIdentifier: cellId)
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
//        tableView.backgroundColor = .blue
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 50
//        tableView.tableFooterView = UIView()
//    }
}
