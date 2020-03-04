//
//  LoadingPlaceholderView.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class LoadingPlaceholderView: BasicPlaceholderView {
    override func setupViews() {
        super.setupViews()

        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .lightGray
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(activityIndicator)

        var allConstraints = [NSLayoutConstraint]()

        let views = ["activity": activityIndicator]

        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[activity]-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: views))
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[activity]|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: views))

        NSLayoutConstraint.activate(allConstraints)
    }
}
