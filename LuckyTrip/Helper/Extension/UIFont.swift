//
//  UIFont.swift
//  Avon Sales
//

import UIKit

extension UIFont
{
    static func robot_reg(_ size:CGFloat)->UIFont
    {
        return UIFont.appFont(weight: .regular, size: size)
    }
    static func roboto_bold(_ size:CGFloat)->UIFont
    {
        return UIFont.appFont(weight: .bold, size: size)
    }
    
}
