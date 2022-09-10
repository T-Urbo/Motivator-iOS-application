//
//  ViewController.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 07/07/2022.
//

//TODO: Choose frameworks -> RxSwift, RxCocoa, WikipediaKit, Kingfisher, SideMenu

import UIKit
import TagListView
import SideMenu

class ViewController: UIViewController, TagListViewDelegate, SideMenuListControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    var quoteController = QuoteController()
    var quoteViewModel = QuoteViewModel()
    var tempTagsArray = [String]()
    var savedAuthorsArray: [Author] = [Author]()
    
    var url: String = "https://api.quotable.io/random"
    
    let nib = UINib(nibName: "QuoteCell", bundle: nil)
    let cellId = "quotecellid"
    
//    let viewControllerSegueIdentifier = "show_author_view_controller"

    private var sideMenu: SideMenuNavigationController?
    let menu = SideMenuListController(with: ["🔎 Search", "✍️ Quote creator", "💾 Saved"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
        setupSideMenu()
        
        
        quoteViewModel.getQuote(from: url) { (quote, error) in
            if quote != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func onSideMenuButtonClick(_ sender: Any) {
        sideMenu!.pushStyle = .default
        present(sideMenu!, animated: true)
    }
    
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: {
            print("\(named) button was pressed")
            
            switch named {
                case "Search": print("0") // push Search vc
                case "Quote creator": print("1") // push Quote creator vc
                case "Saved": print("2") // push Saved content vc
                default: print("...")
            }
        })
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteViewModel.quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotecellid", for: indexPath) as! QuoteCell
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
        
        cell.delegate = self
        
        cell.contentLabel.text = quoteViewModel.quotes[indexPath.row].quoteContent
        
        cell.authorButton.setTitle(quoteViewModel.quotes[indexPath.row].quoteAuthor, for: .normal)
        cell.authorButton.tag = indexPath.row
        cell.authorButton.addTarget(self, action: #selector(onAuthorButtonClick(_:)), for: .touchUpInside)
        
        cell.tagsView.removeAllTags()
        cell.tagsView.addTags(quoteViewModel.quotes[indexPath.row].quoteTags)
        cell.tagsView.delegate = self
        
        return cell
    }
    
    @objc func onAuthorButtonClick(_ button: UIButton) {
        print("the button with tag: \(button.tag) clicked in cell!")
        if let authorpagevc = storyboard?.instantiateViewController(identifier: "apvc") as? AuthorPageViewController {
            authorpagevc.authorName = (button.titleLabel?.text!)!
            self.present(authorpagevc, animated: true, completion: nil)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("tag \(title), \(sender) pressed")
        tagView.onTap = { tagView in
            tagView.selectedTextColor = .gray
            tagView.selectedBackgroundColor = .blue
        }
        if let tagssearchpagevc = storyboard?.instantiateViewController(identifier: "tagssearchpagevc") as? TagsSearchPageViewController {
            tagssearchpagevc.tag = title
            self.navigationController?.pushViewController(tagssearchpagevc, animated: true)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag \(title), \(sender) was removed!")
    }
    
    func setupNavigationController() {
//        self.navigationController?.navigationBar.backgroundColor = .systemBlue
    }
    
    func setupTableView() {
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setupSideMenu() {
        self.menu.delegate = self
        self.sideMenu = SideMenuNavigationController(rootViewController: menu)
        self.sideMenu?.leftSide = true
        self.sideMenu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
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

// MARK: - SaveAuthorDelegate protocol implementation
extension ViewController: SaveAuthorDelegate {
    func saveAuthor(authorName: String) {
        print("delegate")
    }
    
}

extension ViewController: QuoteCellDelegate {
    var _isLiked: Bool {
        get {
            return false
        }
        set {
//            self._isLiked = false
        }
    }

    func onLikeButtonClick(_ button: UIButton) {
        print("like button was tapped!")
    }
}
