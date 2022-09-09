//
//  QuoteCell.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 12/07/2022.
//

//TODO: Create onTagButttonClick function which shows quotes with selected tag/s
//      Add quote saving functionality

import UIKit
import TagListView

class QuoteCell: UITableViewCell, TagListViewDelegate {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var tagsView: TagListView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagsView.tagSelectedBackgroundColor = .blue
        tagsView.selectedTextColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    @IBAction func onAuthorButtonClick(_ sender: UIButton) {
    }
    
    @objc func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag \(title), \(sender) was pressed!")
    }
}
