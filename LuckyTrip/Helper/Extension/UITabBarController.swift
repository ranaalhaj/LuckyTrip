//
//  UITabBarControllerExt.swift
//  Template1
//
//  Created by OmarAltawashi on 6/8/17.
//  Copyright © 2017 UnitOne. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    
    
    func setTabBarVisible(_ visible:Bool, animated:Bool) {
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animate the tabBar
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        UIView.animate(withDuration: animated ? duration : 0.0) {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < self.view.frame.maxY
    }
    
    func setBadges(_ badgeValues: [Int]) {
        
        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                view.removeFromSuperview()
            }
        }
        
        for index in 0...badgeValues.count-1 {
            if badgeValues[index] != 0 {
                addBadge(index, value: badgeValues[index], color:UIColor(red:0.18, green:0.24, blue:0.28, alpha:1.00), font: UIFont(name: "SFUIText-Regular", size: 11.666)!)
            }
        }
    }
    
    func addBadge(_ index: Int, value: Int, color: UIColor, font: UIFont) {
        let badgeView = CustomTabBadge()
        
        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.font = font
        
        badgeView.backgroundColor = color
        badgeView.tag = index
        if  value != 0 {
            badgeView.text =  String(value)
            tabBar.addSubview(badgeView)
        }
        
        self.positionBadges()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        self.positionBadges()
    }
    
    // Positioning
    func positionBadges() {
        
        var tabbarButtons = self.tabBar.subviews.filter { (view: UIView) -> Bool in
            return view.isUserInteractionEnabled // only UITabBarButton are userInteractionEnabled
        }
        
        tabbarButtons = tabbarButtons.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })
        
        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                let badgeView = view as! CustomTabBadge
                self.positionBadge(badgeView, items:tabbarButtons, index: badgeView.tag)
            }
        }
    }
    
    func removeBadgeByIndex(_ index:Int) {
        
        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                let badgeView = view as! CustomTabBadge
                if badgeView.tag == index {
                    badgeView.removeFromSuperview()
                }
            }
        }
    }
    
    func positionBadge(_ badgeView: UIView, items: [UIView], index: Int) {
        
        let itemView = items[index]
        let center = itemView.center
        
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = -10
        badgeView.frame.size = CGSize(width: 18, height: 18)
        badgeView.center = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
        badgeView.layer.cornerRadius = 9.0
        tabBar.bringSubviewToFront(badgeView)
    }
    
    func repositionBadgeLayer(_ badgeView: UIView) {
        if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
            badgeView.layer.transform = CATransform3DIdentity
            badgeView.layer.transform = CATransform3DMakeTranslation(-20.0, 10.0, 1.0)
        }
    }
    
    func repositionBadges(tab: Int? = nil) {
        if let tabIndex = tab {
            for badgeView in self.tabBar.subviews[tabIndex].subviews {
                repositionBadgeLayer(badgeView)
            }
        } else {
            for tabBarSubviews in self.tabBar.subviews {
                for badgeView in tabBarSubviews.subviews {
                    repositionBadgeLayer(badgeView)
                }
            }
        }
    }
    
    
}

class CustomTabBadge: UILabel {}
