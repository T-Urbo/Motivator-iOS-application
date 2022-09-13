//
//  SavedAuthorCell.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 13/09/2022.
//

import UIKit

class SavedAuthorCell: UITableViewCell {

    @IBOutlet weak var savedAuthorImage: UIImageView!
    @IBOutlet weak var savedAuthorName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
