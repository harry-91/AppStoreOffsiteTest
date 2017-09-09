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
            }
        }
        didSet {
            setupAppViews()
        }
    }
    var iconWidth: CGFloat {
        return iconHeigth / 1.5
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

        decelerationRate = UIScrollViewDecelerationRateFast

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        if apps.count > 0 {
            setupAppViews()
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

        if selectedIndex != -1 {
            horizontalDelegate?.horizontalScrollView(self,
                                                     didSelectItemAt: selectedIndex)
        } else {
            selectedIndex = 0
        }
    }


    fileprivate func addConstraints(for appView: UIView, with index: Int, count: Int) {
        NSLayoutConstraint(item: appView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: iconWidth).isActive = true
        NSLayoutConstraint(item: appView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: iconHeigth).isActive = true
        NSLayoutConstraint(item: appView,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: appView.superview,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        if index == 0 {
            NSLayoutConstraint(item: appView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: appView.superview,
                               attribute: .leading,
                               multiplier: 1,
                               constant: leadingPadding).isActive = true
        } else {
            NSLayoutConstraint(item: appView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: appViews.last,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: linePadding).isActive = true

            if index == count - 1 {
                NSLayoutConstraint(item: appView,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: appView.superview,
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
            let index = appViews.index(of: appView) {

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
        var index = (Int)((xPosition - leadingPadding) / (linePadding + iconWidth))
        if index < 0 {
            index = 0
        }
        var item = appViews[index]
        //check if target position is over widthToScrollNextItem of current left item, if so, move to next item
        if (xPosition-item.frame.origin.x > item.frame.size.width * widthToScrollNextItem) {
            item = appViews[index+1]
        }

        return item.frame.origin.x
    }
}
