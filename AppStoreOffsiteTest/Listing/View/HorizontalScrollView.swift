//
//  HorizontalScrollView.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

private let leadingPadding: CGFloat = 10
private let iconHeigth: CGFloat = 150
private let widthToScrollNextItem: CGFloat = 1.0 / 3

private let webImageViewHeigth: CGFloat = 280
private let webImageViewWidth: CGFloat = webImageViewHeigth / (16.0 / 9)

protocol HorizontalScrollViewDelegate: class {
    func horizontalScrollView(_ horizontalScrollView: HorizontalScrollView,
                              didSelectItemAt index: Int)
}

final class HorizontalScrollView: UIScrollView {

    weak var horizontalDelegate: HorizontalScrollViewDelegate?

    var apps = [App]() {
        willSet {
            if newValue.count > 0 {
                subviews.forEach { $0.removeFromSuperview() }
                
                appViews.removeAll()
            }
        }
        didSet {
            setupAppViews()
        }
    }
    var iconWidth: CGFloat {
        return iconHeigth / 1.5
    }
    var imageURLs = [URL]() {
        willSet {
            if newValue.count > 0 {
                subviews.forEach { $0.removeFromSuperview() }
                
                webImageViews.removeAll()
            }
        }
        didSet {
            setupWebImageViews()
        }
    }
    
    var linePadding: CGFloat = 10 {
        didSet {
            guard linePadding != oldValue else {
                return
            }

            subviews.forEach { $0.removeFromSuperview() }

            if apps.count > 0 {
                setupAppViews()
            }

        }
    }
    var selectedIndex: Int = -1 {
        didSet {
            guard selectedIndex != oldValue else {
                return
            }

            horizontalDelegate?.horizontalScrollView(self,
                                                     didSelectItemAt: selectedIndex)
        }
    }

    fileprivate var appViews = [RecommendationAppView]()
    fileprivate var webImageViews = [WebImageView]()
    fileprivate var stringLabels = [UILabel]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    fileprivate func setup() {
        delegate = self

        decelerationRate = UIScrollView.DecelerationRate.fast

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        if apps.count > 0 {
            setupAppViews()
        } else if imageURLs.count > 0 {
            setupWebImageViews()
        }
    }

    fileprivate func setupAppViews() {
        for index in 0 ..< apps.count {
            let appView = RecommendationAppView()
            appView.translatesAutoresizingMaskIntoConstraints = false
            appView.isUserInteractionEnabled = true
            appView.app = apps[index]
            
            addSubview(appView)
            

            addConstraints(for: appView, with: index, count: apps.count)

            appViews.append(appView)
        }
    }
    
    fileprivate func setupWebImageViews() {
        for index in 0 ..< imageURLs.count {
            let imageView = WebImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(with: imageURLs[index])
            imageView.backgroundColor = .white
            
            addSubview(imageView)
            
            addConstraints(for: imageView, with: index, count: imageURLs.count)
            
            webImageViews.append(imageView)
        }
    }


    fileprivate func addConstraints(for view: UIView, with index: Int, count: Int) {
        let isAppView = view is RecommendationAppView
        
        NSLayoutConstraint(item: view,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: isAppView ? iconWidth : webImageViewWidth).isActive = true
        NSLayoutConstraint(item: view,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: isAppView ? iconHeigth : webImageViewHeigth).isActive = true
        NSLayoutConstraint(item: view,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: view.superview,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        if index == 0 {
            NSLayoutConstraint(item: view,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: view.superview,
                               attribute: .leading,
                               multiplier: 1,
                               constant: leadingPadding).isActive = true
        } else {
            NSLayoutConstraint(item: view,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: isAppView ? appViews.last : webImageViews.last,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: linePadding).isActive = true

            if index == count - 1 {
                NSLayoutConstraint(item: view,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: view.superview,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant: -leadingPadding).isActive = true
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        defer {
            super.touchesBegan(touches, with: event)
        }

        let view = hitTest(touch.location(in: self), with: event)

        if let appView = view as? RecommendationAppView,
            let index = appViews.firstIndex(of: appView) {

            selectedIndex = index
        }
    }
}

extension HorizontalScrollView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = targetContentOffset.pointee

        //move to closest item
        if (targetOffset.x + scrollView.frame.size.width < scrollView.contentSize.width) {
            targetContentOffset.pointee.x = self.getClosestItemByX(position:targetOffset.x, inScrollView:scrollView) - leadingPadding
        }
    }

    fileprivate func getClosestItemByX(position xPosition: CGFloat, inScrollView scrollView: UIScrollView) -> CGFloat {
        //get current cloest item on the left side
        var index = (Int)((xPosition - leadingPadding) / (linePadding + (appViews.count > 0 ? iconWidth : webImageViewWidth)))
        if index < 0 {
            index = 0
        }
        var item = appViews.count > 0 ? appViews[index] : webImageViews[index]
        //check if target position is over widthToScrollNextItem of current left item, if so, move to next item
        if (xPosition-item.frame.origin.x > item.frame.size.width * widthToScrollNextItem) {
            item = appViews.count > 0 ? appViews[index + 1] : webImageViews[index + 1]
        }

        return item.frame.origin.x
    }
}
