//
//  CustomUI.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/8/21.
//

import Foundation
import UIKit

class SubscribeGradientButton: UIView{
    
    private var gradient: CAGradientLayer?
    
    override func draw(_ rect: CGRect) {
        self.setGradient(colours: ["D1A455".color,"EFE499".color ], gradientOrientation: .horizontal)
    }
    
    func setGradient(colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        if gradient != nil{
            gradient?.removeFromSuperlayer()
        }
        gradient = CAGradientLayer()
        gradient!.frame = self.bounds
        gradient!.colors = colours.map { $0.cgColor }
        gradient!.startPoint = orientation.startPoint
        gradient!.endPoint = orientation.endPoint
        layer.insertSublayer(gradient!, at: 0)
    }
    
}

class SubscribeGradientView: UIView{
    
    private var gradient: CAGradientLayer?
    
    override func draw(_ rect: CGRect) {
        setGradient(colours: ["181E24".color.withAlphaComponent(0) , "181E24".color], gradientOrientation: .vertical)
    }
    
    func setGradient(colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        if gradient != nil{
            gradient?.removeFromSuperlayer()
        }
        gradient = CAGradientLayer()
        gradient!.frame = self.bounds
        gradient!.colors = colours.map { $0.cgColor }
        gradient!.startPoint = orientation.startPoint
        gradient!.endPoint = orientation.endPoint
        layer.insertSublayer(gradient!, at: 0)
    }
    
}
