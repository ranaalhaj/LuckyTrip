//
//  IGAdditions.swift
//  InstagramStories
//
//  Created by  Boominadha Prakash on 12/11/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import UIKit

extension Int {
    var toFloat: CGFloat {
        return CGFloat(self)
    }
    
    var secondsToTime : String {
        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        
        if h < 1 {
            return  String(format: "%02d:%02d", m,s)
        }
        return  String(format: "%02d:%02d:%02d",h,m,s)
    }
}

extension Float {
    var toInt: Int {
        return Int(self)
    }

    var secondsToTime : String {
        let (h,m,s) = (self.toInt / 3600, (self.toInt % 3600) / 60, (self.toInt % 3600) % 60)
        
        if h < 1 {
            return  String(format: "%02d:%02d", m,s)
        }
        return  String(format: "%02d:%02d:%02d",h,m,s)
    }
}

extension Array {
     func sortedArrayByPosition() -> [Element] {
        return sorted(by: { (obj1 : Element, obj2 : Element) -> Bool in
            
            let view1 = obj1 as! UIView
            let view2 = obj2 as! UIView
            
            let x1 = view1.frame.minX
            let y1 = view1.frame.minY
            let x2 = view2.frame.minX
            let y2 = view2.frame.minY
            
            if y1 != y2 {
                return y1 < y2
            } else {
                return x1 < x2
            }
        })
    }
}
