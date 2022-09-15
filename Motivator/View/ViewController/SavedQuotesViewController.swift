import UIKit
import RxSwift
import TagListView

class SavedQuotesViewController: UIViewController {

    @IBOutlet weak var savedQuotesTableView: UITableView!
    
    private var savedQuotes: [CoreDataQuoteModel] = []
    private var coreDataService = CoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - SavedQuotesViewController tableView Delegate and DataSource protocols conformance

extension SavedQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saved_quotes_vc_tv_id", for: indexPath) as! QuoteCellViewModel
        cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: tableView.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
        cell.selectionStyle = .none
        cell.delegate = self
        
        cell.contentLabel.text = savedQuotes[indexPath.row].quoteModel.quoteContent
        
        cell.authorButton.setTitle(savedQuotes[indexPath.row].quoteModel.quoteAuthor, for: .normal)
        cell.authorButton.tag = indexPath.row
        
        cell.tagsView.removeAllTags()
        cell.tagsView.addTags(savedQuotes[indexPath.row].quoteModel.quoteTags)
        cell.tagsView.delegate = self
        
        cell.likeButton.tag = indexPath.row
        
        return cell
    }
}

// MARK: - SavedQuotesViewController QuoteCellViewModelDelegate protocol conformance

extension SavedQuotesViewController: QuoteCellViewModelDelegate {
    var _isLiked: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    func onLikeButtonClick(_ sender: UIButton) {
        print("SavedQuoteViewController onLikeButtonClick")
    }
    
    func onAuthorButtonClick(_ sender: UIButton) {
        print("SavedQuoteViewController onAuthorButtonClick")
    }
}

// MARK: - SavedQuotesViewController TagListViewDelegate protocol conformance

extension SavedQuotesViewController: TagListViewDelegate {
    // special setup for this vc for tag events handling
}
