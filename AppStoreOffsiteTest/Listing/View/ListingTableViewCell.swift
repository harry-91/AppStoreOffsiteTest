//
//  ListingTableViewCell.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    
    var number: Int = 0 {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    var app: App? {
        didSet {
            webImageView.setImage(with: app?.iconURL)
            titleLabel.text = app?.title
            categoryLabel.text = app?.category
            rateDisplayView.currentRating = CGFloat(app?.detail?.averageUserRating ?? 0)
            
            rateDisplayView.isHidden = rateDisplayView.currentRating == 0
        }
    }

    @IBOutlet fileprivate weak var numberLabel: UILabel!
    @IBOutlet fileprivate weak var webImageView: WebImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var categoryLabel: UILabel!
    @IBOutlet fileprivate weak var rateDisplayView: RateDisplayView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
