//
//  QuoteCell.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 12/07/2022.
//

import UIKit
import TagListView

class QuoteCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tagsView: TagListView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
