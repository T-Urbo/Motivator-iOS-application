//
//  QuoteCell.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 12/07/2022.
//

// TODO: - Add quote saving functionality
// TODO: - Fix bug with like "jumping" - after opening authorpagevc like on current quote jumps to another quote

import UIKit
import TagListView

protocol QuoteCellDelegate: AnyObject {
    var _isLiked: Bool {get set}
    func onLikeButtonClick(_ button: UIButton)
}

class QuoteCell: UITableViewCell, TagListViewDelegate {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var tagsView: TagListView!
    @IBOutlet weak var likeButton: UIButton!
    
    var isLiked: Bool = false
    private let anumationDuration: Double = 0.1
    private var animationScale: CGFloat {
        isLiked ? 0.7 : 1.3
    }
    private var animate = false
    
    weak var delegate: QuoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagsView.tagSelectedBackgroundColor = .blue
        tagsView.selectedTextColor = .gray
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.onContentLabelDoubleClick(_:)))
        doubleTap.numberOfTapsRequired = 2
        
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(doubleTap)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    // MARK: - Quote like function
    
    @IBAction func onLikeButtonClick(_ sender: Any) {
        isLiked = !isLiked
        switch isLiked {
        case true:
            if let image = UIImage(systemName: "heart.fill") {
                likeButton.setImage(image, for: .normal)
//                likeButton.imageView?.image?
            }
        case false:
            if let image = UIImage(systemName: "heart") {
                likeButton.setImage(image, for: .normal)
//                likeButton.imageView?.image?.scale = 0.7
            }
        }
        
        
        
        print("like button was printed!, isLiked: \(isLiked)")
    }
    
    @objc func onContentLabelDoubleClick(_ sender: Any) {
        print("label was double tapped")
        isLiked = !isLiked
        switch isLiked {
        case true:
            if let image = UIImage(systemName: "heart.fill") {
                likeButton.setImage(image, for: .normal)
            }
        case false:
            if let image = UIImage(systemName: "heart") {
                likeButton.setImage(image, for: .normal)
            }
        }
    }
    
    
    @IBAction func onAuthorButtonClick(_ sender: UIButton) {
        
    }
    
    @objc func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag \(title), \(sender) was pressed!")
    }
}
