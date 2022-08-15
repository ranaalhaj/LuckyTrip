//
//  TabbarViewController.swift
//
//  Created by Rana Alhaj on 14/8/2022.
//

import UIKit
class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

      //  setUpViewController()
        setUpTabs()
       
        
     /*   self.delegate = self
        guard let item = tabBar.items else {return}
        for (i , item) in item.enumerated() {
            item.tag = i
        }*/
    }
    
    func setUpTabs(){
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "ic_tab_home")
        myTabBarItem1.title = "home".localized
      
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "ic_tab_saved")
        myTabBarItem2.title = "For me".localized
    }
 /*   func setUpViewController()
    {
        let home = UIStoryboard.loadFromHome("homeNav") as! UINavigationController

        let braowse = UIStoryboard.load(from: .Browse, identifier: "browseNav") as! UINavigationController
        let live = UIStoryboard.load(from: .Live, identifier: "liveNav") as! UINavigationController
        let myList = UIStoryboard.load(from: .MyList, identifier: "myListNav") as! UINavigationController
        let more = UIStoryboard.load(from: .More, identifier: "moreNav") as! UINavigationController
    
        self.viewControllers = [home,braowse,live,myList,more]

    }*/
  
}


extension TabbarViewController : UITabBarControllerDelegate {
     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let item = tabBar.selectedItem else {return false}
    
        return true
    }
    
    private func getSelectViewController() -> UIViewController? {
        if let nav = selectedViewController as? UINavigationController {
            return nav.topViewController
        }
        return nil
    }
}
