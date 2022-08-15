//
//  AppDelegetExt.swift
//  iOSTemplate
//
//  Created by Omar Al tawashi on 7/11/17.
//  Copyright © 2017 Omar Al tawashi. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    
    func switchRootVC(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if #available(iOS 13.0, *) {
            switchRootViewController(rootViewController: rootViewController, animated: animated, option: .transitionCrossDissolve, completion: completion)
        } else {
            switchRootViewControllerIOS12(rootViewController: rootViewController, animated: animated, option: .transitionCrossDissolve, completion: completion)
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    func switchRootViewController(rootViewController: UIViewController, animated: Bool , option : UIView.AnimationOptions, completion: (() -> Void)?) {
        if animated {
//            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            UIView.transition(with: UIApplication.shared.windows.first!, duration: 0.5, options: option, animations: {
                
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                UIApplication.shared.windows.first?.rootViewController = rootViewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                
                 if (completion != nil) {
                    completion!()
                }
            })
        } else {
            UIApplication.shared.windows.first?.rootViewController = rootViewController
            
        }
    }
    
    func switchRootViewControllerIOS12(rootViewController: UIViewController, animated: Bool,option:UIView.AnimationOptions , completion: (() -> Void)?) {
        if animated {

             UIView.transition(with: window!, duration: 0.5, options: option, animations: {

                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window!.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in

                 if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window!.rootViewController = rootViewController
        }
    }
}



