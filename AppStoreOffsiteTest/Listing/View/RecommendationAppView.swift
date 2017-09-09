//
//  RecommendationAppView.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class RecommendationAppView: UIView {
    
    var app: App? {
        didSet {
            guard let app = app else {
                imageView.image = nil
                titleLabel.text = ""
                categoryLabel.text = ""
                
                return
            }
            
            imageView.setImage(with: app.iconURL)
            titleLabel.text = app.title
            categoryLabel.text = app.category
        }
    }
    
    fileprivate lazy var imageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        
        return titleLabel
    }()
    fileprivate lazy var categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.numberOfLines = 1
        categoryLabel.font = UIFont.systemFont(ofSize: 13)
        categoryLabel.textColor = UIColor.gray
        
        return categoryLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }

    
    fileprivate func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(categoryLabel)
        
        var allConstraints = [NSLayoutConstraint]()
        
        let views = ["imageView": imageView,
                     "titleLabel": titleLabel,
                     "categoryLabel": categoryLabel] as [String : Any]
        
        allConstraints.append(NSLayoutConstraint(item: imageView,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: imageView,
                                                 attribute: .width,
                                                 multiplier: 1,
                                                 constant: 0))
        
        allConstraints.append(NSLayoutConstraint(item: titleLabel,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: imageView,
                                                 attribute: .width,
                                                 multiplier: 1,
                                                 constant: 0))
        
        allConstraints.append(NSLayoutConstraint(item: categoryLabel,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: imageView,
                                                 attribute: .width,
                                                 multiplier: 1,
                                                 constant: 0))
        
        
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-5-[titleLabel]-0-[categoryLabel]-0-|",
                                                                         options: [.alignAllCenterX],
                                                                         metrics: nil,
                                                                         views: views))
        
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[imageView]-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: views))
        
        
        NSLayoutConstraint.activate(allConstraints)
    }
}
