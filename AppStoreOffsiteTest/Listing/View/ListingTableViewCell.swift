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
            
            if number % 2 == 0 {
                webImageView.layer.cornerRadius = webImageView.bounds.width / 2
            } else {
                webImageView.layer.cornerRadius = 20
            }
        }
    }
    var app: App? {
        didSet {
            webImageView.setImage(with: app?.iconURL)
            titleLabel.text = app?.title
            categoryLabel.text = app?.category
            rateDisplayView.currentRating = CGFloat(app?.detail?.averageUserRating ?? 0)
            rateLabel.text = "(\(Int(app?.detail?.userRatingCount ?? 0)))"
            
            rateContainerView.isHidden = rateDisplayView.currentRating == 0
        }
    }

    @IBOutlet fileprivate weak var numberLabel: UILabel!
    @IBOutlet fileprivate weak var webImageView: WebImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var categoryLabel: UILabel!
    @IBOutlet fileprivate weak var rateDisplayView: RateDisplayView!
    @IBOutlet fileprivate weak var rateLabel: UILabel!
    @IBOutlet fileprivate weak var rateContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        webImageView.layer.borderWidth = 1
        webImageView.layer.borderColor = UIColor.lightGray.cgColor
        webImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
