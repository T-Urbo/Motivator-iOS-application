//TODO: Choose frameworks -> RxSwift, RxCocoa, WikipediaKit, Kingfisher, SideMenu

import UIKit
import TagListView
import SideMenu
import RxSwift

class ViewController: UIViewController, TagListViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    public var quoteController = QuoteController()
    public var quoteViewModel = QuoteViewModel()
    public var tempTagsArray = [String]()
    public var savedAuthorsArray: [Author] = [Author]()
    private var sideMenuViewController =  SideMenuViewController()
    private var sideMenu: SideMenuNavigationController?
    
    
    var selfNavigationController: UINavigationController?
    
    public enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    lazy var coreDataService = CoreDataService()
    let disposeBag = DisposeBag()
    var quoteObserver = PublishSubject<CoreDataQuoteModel>()
    
    var url: String = "https://api.quotable.io/random"
    
    let nib = UINib(nibName: "QuoteCellViewModel", bundle: nil)
    let cellId = "QuoteCellViewModelid"
    
    var revealSideMenuOnTop: Bool = true
    
    var isLiked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
//        setupSideMenu()
            
        quoteViewModel.getQuote(from: url) { (quote, error) in
            if quote != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func onMenuButtonClick(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
            if(sideMenu!.isBeingPresented) {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
                    sender.image = UIImage(systemName: "xmark")
                }, completion: nil)
                menuState = .closed
                print("opened")
            }
            if(sideMenu!.isBeingDismissed) {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
                    sender.image = UIImage(systemName: "line.3.horizontal")
                }, completion: nil)
                menuState = .opened
                print("closed")
            }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteViewModel.quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCellViewModelid", for: indexPath) as! QuoteCellViewModel
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
        cell.selectionStyle = .none
        cell.delegate = self
        
        cell.contentLabel.text = quoteViewModel.quotes[indexPath.row].quoteContent
        
        cell.authorButton.setTitle(quoteViewModel.quotes[indexPath.row].quoteAuthor, for: .normal)
        cell.authorButton.tag = indexPath.row
        
        cell.tagsView.removeAllTags()
        cell.tagsView.addTags(quoteViewModel.quotes[indexPath.row].quoteTags)
        cell.tagsView.delegate = self
        
        cell.likeButton.tag = indexPath.row
        
        return cell
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
        sideMenu = SideMenuNavigationController(rootViewController: SideMenuListController(with: ["Saved"]))
        sideMenu?.tabBarItem.image = UIImage(systemName: "line.3.horizontal")
        sideMenu?.leftSide = true
        
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
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

// MARK: - SaveAuthorDelegate protocol
extension ViewController: SaveAuthorDelegate {
    func saveAuthor(authorName: String) {
        print("delegate")
    }
    
}

extension ViewController: QuoteCellViewModelDelegate {
    
    var _isLiked: Bool {
        get {
            return self.isLiked
        }
        set {
            
        }
    }
    
    func onLikeButtonClick(_ sender: UIButton) {
        print("BUTTON WAS TAPPED DELEGATE!!!: \(sender.tag)")
        isLiked = !isLiked
        let newSavedQuote = SavedQuote(context: coreDataService.viewContext)
        newSavedQuote.quote?.quoteModel = quoteViewModel.quotes[sender.tag]
        
        switch isLiked {
        case true:
            do {
                try coreDataService.viewContext.save()
            } catch {
                print("Liked quote saving error: \(error.localizedDescription)")
            }
        case false:
            do {
                coreDataService.viewContext.delete(newSavedQuote)
            }
        }
    }
    
    func onAuthorButtonClick(_ sender: UIButton) {
        print("the button with tag: \(sender.tag) clicked in cell!")
        if let authorpagevc = storyboard?.instantiateViewController(identifier: "apvc") as? AuthorPageViewController {
            authorpagevc.authorName = (sender.titleLabel?.text!)!
            self.present(authorpagevc, animated: true, completion: nil)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController: SideMenuListControllerDelegate {
    func didSelectMenuItem(named: String) {
        print(named)
        if let savedquotesvc = storyboard?.instantiateViewController(identifier: "savedquotesvc") as? SavedQuotesViewController {
        self.present(savedquotesvc, animated: true, completion: nil)
    }
}
}
