//
//  EmptyPlaceholderView.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

class EmptyPlaceholderView: BasicPlaceholderView {
    var title: String? {
        set {
            guard let title = newValue else {
                titleLabel.attributedText = nil

                return
            }

            titleLabel.attributedText =
                NSAttributedString(string: title,
                                   attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                                                NSAttributedString.Key.foregroundColor: UIColor.black])
        }

        get {
            return titleLabel.attributedText?.string
        }
    }
    var details: String? {
        set {
            guard let details = newValue else {
                detailsLabel.attributedText = nil

                return
            }

            detailsLabel.attributedText =
                NSAttributedString(string: details,
                                   attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                NSAttributedString.Key.foregroundColor: UIColor.gray])
        }

        get {
            return detailsLabel.attributedText?.string
        }
    }

    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        return titleLabel
    }()
    fileprivate lazy var detailsLabel: UILabel = {
        let detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0

        return detailsLabel
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    internal override func setupViews() {
        super.setupViews()

        centerView.addSubview(titleLabel)
        centerView.addSubview(detailsLabel)

        var allConstraints = [NSLayoutConstraint]()

        let views = ["titleLabel": titleLabel,
                     "detailsLabel": detailsLabel]


        // TitleLabel & DetailsLabel
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[titleLabel]-0-|",
                                                                         options: .alignAllCenterY,
                                                                         metrics: nil,
                                                                         views: views))
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[detailsLabel]-0-|",
                                                                         options: .alignAllCenterY,
                                                                         metrics: nil,
                                                                         views: views))
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-[detailsLabel]-|",
                                                                         options: .alignAllCenterX,
                                                                         metrics: nil,
                                                                         views: views))
        
        NSLayoutConstraint.activate(allConstraints)
    }
}
