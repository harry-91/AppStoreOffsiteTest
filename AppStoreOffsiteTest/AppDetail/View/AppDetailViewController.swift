//
//  AppDetailViewController.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 10/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController {
    var eventHandler: AppDetailModuleInterface?

    @IBOutlet fileprivate weak var imageView: WebImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var artistLabel: UILabel!
    @IBOutlet fileprivate weak var rateContainerView: UIView!
    @IBOutlet fileprivate weak var rateDisplayView: RateDisplayView!
    @IBOutlet fileprivate weak var rateLabel: UILabel!
    @IBOutlet fileprivate weak var scrollView: HorizontalScrollView!
    @IBOutlet fileprivate weak var summaryLabel: UILabel!
    @IBOutlet fileprivate weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var screenshotsTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventHandler?.viewDidLoad()
        
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - AppDetailViewInterface

extension AppDetailViewController: AppDetailViewInterface {
    func update(app: App) {
        imageView.setImage(with: app.iconURL)
        titleLabel.text = app.title
        artistLabel.text = app.artist
        rateDisplayView.currentRating = CGFloat(app.detail?.averageUserRating ?? 0)
        rateLabel.text = "(\(Int(app.detail?.userRatingCount ?? 0)))"
        summaryLabel.text = app.summary
        
        rateContainerView.isHidden = app.detail?.userRatingCount ?? 0 == 0
        
        let imageURLs = app.detail?.screenshotURLs ?? []
        if imageURLs.count == 0 {
            scrollViewHeightConstraint.constant = 0
            screenshotsTitle.isHidden = true
        } else {
            scrollView.imageURLs = imageURLs
        }
    }
}
