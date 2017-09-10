//
//  RecommendationTableViewCell.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

protocol RecommendationTableViewCellDelegate: class {
    func recommendationTableViewCell(_ recommendationTableViewCell: RecommendationTableViewCell,
                                     didSelectItemAt index: Int)
}

class RecommendationTableViewCell: UITableViewCell {
    
    weak var delegate: RecommendationTableViewCellDelegate?
    
    @IBOutlet weak fileprivate var scrollView: HorizontalScrollView!
    
    fileprivate lazy var emptyView: EmptyPlaceholderView = {
        let emptyView = EmptyPlaceholderView(frame: self.bounds)
        emptyView.backgroundColor = .white
        emptyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        emptyView.title = "No Result"
        emptyView.isHidden = true
        
        self.addSubview(emptyView)
        
        return emptyView
    }()
    
    var grossingApps = [App]() {
        didSet {
            scrollView.apps = grossingApps
            
            emptyView.isHidden = grossingApps.count != 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        scrollView.horizontalDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension RecommendationTableViewCell: HorizontalScrollViewDelegate {
    func horizontalScrollView(_ horizontalScrollView: HorizontalScrollView,
                              didSelectItemAt index: Int){
        delegate?.recommendationTableViewCell(self,
                                              didSelectItemAt: index)
    }
}
