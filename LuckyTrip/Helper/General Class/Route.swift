import UIKit

class Route: NSObject {
    
    static let Delegte = UIApplication.shared.delegate as! AppDelegate

    //MARK: Public Style Appearance
    static func publicStyleAppearance() {
        
        //style
        let navBar = UINavigationBar.appearance()
        navBar.isTranslucent = false
        navBar.barTintColor = "1F242D".color
        navBar.tintColor = .white
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                      .font: UIFont.appFont(weight: .bold, size: 16)]

       
        setNewNavigationApperance()
    }
    
    static func goSplashScreen(){
    //        let window = wind
          
            
            //guard let window = getWindow() else {print("no current window");return}
            let nav = UIStoryboard.load(from: .SplashScreen, identifier: "SplashScreenVc")
            UIApplication.shared.windows.first?.rootViewController = nav
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            //window.rootViewController = nav
    //        UIView.transition(with: window!, duration: 0.3 , options: .transitionCrossDissolve,
    //                          animations: nil, completion: nil)
               
        }
    
    static func topVC() -> UIViewController? {
        var window : UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        } else {
            window = UIApplication.shared.keyWindow
        }

        guard let _window = window else {return nil}
        var tabbar : TabbarViewController?

        if let root = _window.rootViewController as? TabbarViewController {
            tabbar = root
        }
        guard let root = tabbar else {return nil}
        guard let nav = root.selectedViewController as? UINavigationController  else {return nil}
        guard let visibleVC = nav.visibleViewController else {return nil}
//        guard let topVC = nav.topViewController  else {return nil}
        return visibleVC
    }

   
    
    static func setNewNavigationApperance(){
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black_1F242D
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                              .font: UIFont.appFont(weight: .bold, size: 16)]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }
        
    }
    static func setNewTabbarContollerApperance(){
        UITabBar.appearance().tintColor = .pink_F42FBD
        if #available(iOS 15, *) {
           let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .black_1F242D
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.pink_F42FBD,.font:UIFont.appFont(weight: .bold, size: 10.0)]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray_A3AEC3,.font:UIFont.appFont(weight: .bold, size: 10.0)]
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.pink_F42FBD,.font:UIFont.appFont(weight: .bold, size: 10.0)], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray_A3AEC3,.font:UIFont.appFont(weight: .bold, size: 10.0)], for: .normal)
            UITabBar.appearance().barTintColor = .black_1F242D
         }
    }
    
    //MARK:- set viewControler is Root application One Way :-
    static func goUserHome() {
        guard let window = getWindow() else {return}
        let nav = UIStoryboard.loadFromMain("HomeUser") as! UINavigationController
        window.rootViewController = nav
        UIView.transition(with: window, duration: 0.3 , options: .transitionCrossDissolve,
                          animations: nil, completion: nil)
    }
    static func goCheckPhone() {
        guard let window = getWindow() else {print("no current window");return}
        let nav = UIStoryboard.load(from: .authentication, identifier: "checkPhoneNav") as! UINavigationController
        window.rootViewController = nav
        UIView.transition(with: window, duration: 0.3 , options: .transitionCrossDissolve,
                          animations: nil, completion: nil)

    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    static func clearDataOfCashed(){
        _userDefaults.removeObject(forKey: AppConstants.KeyUserObject)
        _userDefaults.removeObject(forKey: AppConstants.tokenAuth)
        _userDefaults.removeObject(forKey: AppConstants.oldFcmToken)
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
//        KeyChain.delete(key: AppConstants.passwordEncrypt)
    }
    
    static func goUserInterests() {
        let nav = UIStoryboard.load(from: .authentication, identifier: "InterestedCategoriesNav") as! UINavigationController
        Delegte.switchRootVC(rootViewController: nav, animated: true, completion: nil)
    }
    
    //MARK:- set viewControler is Root application two Way :-
    static func goHome() {
        let tabbar = UIStoryboard.loadFromMain("TabbarViewController") as! TabbarViewController
//        //Delegte.switchRootVC(rootViewController: tabbar, animated: true, completion: nil)
        UIApplication.shared.windows.first?.rootViewController = tabbar
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//           return
//         }
//
//        guard let window = appDelegate.window else {
//           return
//        }
//        guard let window = self.window else {
//            return
//        }
//        window.rootViewController = tabbar
//        window.makeKeyAndVisible()
    }
    static func getWindow() -> UIWindow? {
        return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
    }
}


extension Route {
        var window: UIWindow? {
            if #available(iOS 13, *) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
                       return window
            }
            
            guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else { return nil }
            return window
        }
    }


extension UIViewController {
        var window: UIWindow? {
            if #available(iOS 13, *) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
                       return window
            }
            
            guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else { return nil }
            return window
        }
    }
