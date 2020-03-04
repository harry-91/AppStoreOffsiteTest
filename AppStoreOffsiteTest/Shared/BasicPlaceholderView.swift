//
//  BasicPlaceholderView.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class BasicPlaceholderView: UIView {

    let centerView: UIView = {
        let centerView = UIView()
        centerView.translatesAutoresizingMaskIntoConstraints = false

        return centerView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }

    func setupViews() {
        backgroundColor = UIColor.white

        addSubview(centerView)

        var allConstraints = [NSLayoutConstraint]()

        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-(>=20)-[centerView]-(>=20)-|",
                                                                         options: .alignAllCenterX,
                                                                         metrics: nil,
                                                                         views: ["centerView": centerView]))
        allConstraints.append(NSLayoutConstraint(item: centerView,
                                                 attribute: .centerY,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .centerY,
                                                 multiplier: 1.0, constant: 0.0))
        let centerConstraint = NSLayoutConstraint(item: centerView,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .centerX,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        centerConstraint.priority = UILayoutPriority(rawValue: 750)
        allConstraints.append(centerConstraint)

        NSLayoutConstraint.activate(allConstraints)
    }
    
}
