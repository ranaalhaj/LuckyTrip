//
//  UILabel.swift
//  Viviane

import Foundation
import UIKit

extension UILabel {
    func setShadowText(){
        let attString = NSMutableAttributedString(string: text ?? "")
        let range = NSRange(location: 0, length: attString.length)

        if let f = font {
            attString.addAttribute(.font, value: f, range: range)
        }
        if let tc = textColor {
            attString.addAttribute(.foregroundColor, value: tc, range: range)
        }

        let shadow = NSShadow()
        shadow.shadowColor = UIColor.systemBlue
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 2
        attString.addAttribute(.shadow, value: shadow, range: range)

        attributedText = attString
    }
    func addSpacing(text:String,lineSapacing:CGFloat,aligment:NSTextAlignment = .right){
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSapacing
        paragraphStyle.alignment = aligment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString

    }
    
    func setParagraphLine(_ text:String,_ space:CGFloat=8) {
        let parag = NSMutableParagraphStyle()
        parag.lineSpacing = space
        let attributedText = NSMutableAttributedString(string: text,attributes: [.paragraphStyle : parag])
        self.attributedText = attributedText
    }
}
