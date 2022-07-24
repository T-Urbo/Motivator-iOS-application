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

class QuoteCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var tagsView: TagListView!
//    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onAuthorButtonClick(_ sender: UIButton) {
    }
}
