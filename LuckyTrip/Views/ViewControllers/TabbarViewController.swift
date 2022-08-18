//
//  TabbarViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  This Class is for Mian page which includes two tabs one for home page and the second for my saved destinations



import UIKit
class TabbarViewController: UITabBarController {

    //MARK:  FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        
    }
    
    func setUpTabs(){
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "ic_tab_home")
        myTabBarItem1.title = "home".localized()
      
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "ic_tab_saved")
        myTabBarItem2.title = "For me".localized()
        
    }

}

