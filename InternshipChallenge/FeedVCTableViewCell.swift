//
//  FeedVCTableViewCell.swift
//  InternshipChallenge
//
//  Created by ALI on 12.12.2020.
//  Copyright © 2020 alikorkmaz. All rights reserved.
//

import UIKit

// This class was created to set imageView and textLabel for each cell in the tableView.
class FeedVCTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Here is the some codes to make the image circular. Also, to fit the texts in the labels.
        titleLabel.insetsLayoutMarginsFromSafeArea = false
        titleLabel?.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleImage.layer.masksToBounds = true
        titleImage.layer.cornerRadius = titleImage.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
