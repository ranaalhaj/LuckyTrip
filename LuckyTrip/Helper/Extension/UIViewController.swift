//
//  UIViewController.swift
//  BabySitter
//
//

import UIKit
import MBProgressHUD
import SystemConfiguration

extension UIViewController{
    
    
    func setNavigationBarHidden(_ value:Bool=true) {
        self.navigationController?.setNavigationBarHidden(value, animated: true)
    }
    
    func setBackButtonHidden(_ value:Bool=true) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }


    func setNewClearNavigationApperance(nav:UINavigationBar){
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = nav.barTintColor
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = nav.titleTextAttributes ?? [:]


            nav.standardAppearance = appearance
            nav.scrollEdgeAppearance = appearance
        }
    }
    func setNavClear(){
        guard let nc = navigationController else {return}
        let navBar = nc.navigationBar
        navBar.isTranslucent = true
        navBar.barTintColor = .clear
        navBar.shadowImage = UIImage()
        navBar.tintColor = .white
        navBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.largeTitleDisplayMode = .never
        nc.view.backgroundColor = .clear
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                      .font: UIFont.appFont(weight: .bold, size: 16)]
        hideBackWord()
        setNewClearNavigationApperance(nav: navBar)

    }
  
    func hideBackWord(){
        navigationItem.hideBackWord()
    }
    
    func largeNavStyle(){
        guard let nc = navigationController else {return}
        navigationItem.largeTitleDisplayMode = .always
        let navBar = nc.navigationBar
        navBar.isTranslucent = true
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.appFont(weight: .regular, size: 24) ]
    }
    
    func pushVC(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentVC(_ vc:UIViewController){
        present(vc, animated: true, completion: nil)
    }
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
   
    func popToRootVC(_ animated:Bool=true){
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
  
    @objc func goBack(sender: UIBarButtonItem){
        self.popVC()
    }
    

    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func setCustomBack(){
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        rightBarButton.setBackgroundImage(UIImage(named: "back-icon"), for: .normal)
        rightBarButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func back(){
        popVC()
    }    
    func didFailedCallBack(_ error:NSError?){
        DispatchQueue.main.async { [weak self] in
            guard let wself = self else {return}
            Utl.ShowLoading(status: Hide, View: wself.view)
            Utl.ShowLoading2(status: Hide, View: wself.view)
            guard let error = error else {
                return
            }
            Utl.ShowNotfication(Status: Failed, Body: "Network connection error".localized)
            
            if error.code == 403 {
                
            }else{
                if error.code == 401{
                    wself.setNavClear()
                
                }
            }
          
        }
    }
    
    func handlerStatusResponse(status:Bool?,error:String?) -> Bool{
        guard let status = status , status == true else {
            Utl.ShowNotfication(Status: Failed, Body: error ?? "")
            return false
        }
        return true
    }
    
}

extension UINavigationItem {
    func hideBackWord()  {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.backBarButtonItem = backItem
    }
}
