//
//  Utilities.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//

import UIKit
import Foundation
import SystemConfiguration
import SwiftMessages

class Utilities: NSObject {
    
    
    func ShowNotfication(Status:Int,Body:String)
    {
        
        SwiftMessages.hideAll()
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.success)
        view.iconImageView?.isHidden = true
        view.button?.isHidden = true
        view.backgroundView.backgroundColor = .clear
        view.titleLabel?.textAlignment = .center
        view.bodyLabel?.textAlignment = .center
        view.titleLabel?.isHidden = true
        var BGColor = UIColor()
        
        if(Status == ResultType.success.rawValue)
        {
            BGColor = .systemGreen
        }else
        {
            BGColor = .systemRed
        }
        
        view.backgroundColor = BGColor
        view.configureContent(title: "" , body: Body)
        
        SwiftMessages.show(view: view)
    }
    
    
}

