//
//  ViewController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 07/07/2022.
//

//TODO: Choose frameworks -> RxSwift, RxCocoa, WikipediaKit, Kingfisher, SideMenu
//      Decide about the architecture -> MVVM
//      Find an API source of quotes: quotable.io
//      Make a segue to AuthorPageViewController if authorButton(QuoteCell.swift) was clicked


import UIKit
import RxSwift
import TagListView
import SideMenu

enum URLSessionErrors: Error {
    case invalidURL
}

class ViewController: UIViewController, TagListViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    var quoteController = QuoteController()
    //    var quoteViewModels = [QuoteViewModel]()
    var quoteViewModel = QuoteViewModel()
    var tempTagsArray = [String]()
    
    var url: String = "https://api.quotable.io/random"
    let cellId = "quotecellid"
    let nib = UINib(nibName: "QuoteCell", bundle: nil)
    
    let viewControllerSegueIdentifier = "show_author_view_controller"

    private let sideMenu = SideMenuNavigationController(rootViewController: UIViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
        
        quoteViewModel.getQuote(from: url) { (quote, error) in
            if quote != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func onSideMenuButtonClick(_ sender: Any) {
        present(sideMenu, animated: true)
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteViewModel.quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotecellid", for: indexPath) as! QuoteCell
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
        
        cell.contentLabel.text = quoteViewModel.quotes[indexPath.row].quoteContent
        cell.authorButton.setTitle(quoteViewModel.quotes[indexPath.row].quoteAuthor, for: .normal)
        
        // Problem is in here //
        cell.tagsView.removeAllTags()
        cell.tagsView.addTags(quoteViewModel.quotes[indexPath.row].quoteTags)
        cell.tagsView.delegate = self
        
        cell.authorButton.tag = indexPath.row
        cell.authorButton.addTarget(self, action: #selector(onAuthorButtonClick(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc func onAuthorButtonClick(_ button: UIButton) {
        print("the button with tag: \(button.tag) clicked in cell!")
        if let authorpagevc = storyboard?.instantiateViewController(identifier: "apvc") as? AuthorPageViewController {
            authorpagevc.authorName = (button.titleLabel?.text!)!
            authorpagevc.title = (button.titleLabel?.text!)!
            self.present(authorpagevc, animated: true, completion: nil)
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tagClicked(title: String, tagView: TagView, sender: TagListView) {
        print("tag pressed: \(title), \(sender)")
    }
        
    func authorButtonTapped(_ cell: QuoteCell) {
        let indexPath = self.tableView.indexPath(for: cell)
    }
    
    func setupNavigationController() {
        
        self.navigationController?.navigationBar.backgroundColor = .systemBlue
        self.sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
    }
    
    func setupTableView() {
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        
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
            quoteViewModel.getQuote(from: url, completionHandler: { (quote, error) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        })
        }
    }
}
