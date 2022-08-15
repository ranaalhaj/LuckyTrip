//
//  UIViewController.swift
//  BabySitter
//
//  Created by Sobhi Imad on 6/21/20.
//  Copyright © 2020 UnitOne. All rights reserved.
//

import UIKit
import MBProgressHUD
import SystemConfiguration
import KLCPopup
import StoreKit

extension UIViewController{
    
    
    func setNavigationBarHidden(_ value:Bool=true) {
        self.navigationController?.setNavigationBarHidden(value, animated: true)
    }
    
    func setBackButtonHidden(_ value:Bool=true) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setBackBtn(){
        let navBar = self.navigationController?.navigationBar
        var backImage:UIImage? = UIImage(named: "back-icon")?.withRenderingMode(.alwaysOriginal)
        let leftPadding: CGFloat = 10
        let adjustSizeForBetterHorizontalAlignment: CGSize = CGSize(width: backImage!.size.width + leftPadding, height: backImage!.size.height)
        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0)
        backImage!.draw(at: CGPoint(x: leftPadding, y: 0))
        backImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navBar?.backIndicatorImage = backImage
        navBar?.backIndicatorTransitionMaskImage = backImage
        navBar?.backItem?.title = ""
        navBar?.tintColor = .black
        
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -20.0, vertical: 0.0), for: .default)
    }
    
    func setNavStyle(_ barColor: UIColor = "1F242D".color){
         guard let nc = navigationController else {return}
         let navBar = nc.navigationBar
         navBar.isTranslucent = false
         navBar.barTintColor = barColor
         navBar.tintColor = .white
         navBar.shadowImage = UIImage()
         navBar.setBackgroundImage(UIImage(), for: .default)
         navigationItem.largeTitleDisplayMode = .never
         navBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.appFont(weight: .bold, size: 16)]
         hideBackWord()
         setNewNavigationApperance(nav: navBar)
     }
     
     //style
     func setNewNavigationApperance(nav:UINavigationBar){
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
    
    func  setNewClearNavigationApperance(nav:UINavigationBar){
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            
            appearance.titleTextAttributes = nav.titleTextAttributes ?? [:]

            nav.standardAppearance = appearance
            nav.scrollEdgeAppearance = appearance
            nav.compactAppearance = appearance
        }
    }

    func setNavClear(){

        guard let nc = navigationController else {return}
        let navBar = nc.navigationBar
//        let navBar = UINavigationBar.appearance()
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
    func setBarButtonItemRight(title:String,action:Selector?){
        let rightButton = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        rightButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.appFont(weight: .bold, size: 14.0)], for: .normal)
        rightButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.appFont(weight: .bold, size: 14.0)], for: .highlighted)
        self.navigationItem.rightBarButtonItem = rightButton
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
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func showMessage(_ message:String) {
        self.showErrorMessage(message: message)
    }
    
    func popToSpecificVC(vc:UIViewController.Type ,_ animated:Bool = true) {
        for _vc in self.navigationController!.viewControllers as Array {
            if _vc.isKind(of: vc) {
                self.navigationController!.popToViewController(_vc, animated: animated)
                break
            }
        }
    }
    
    func setBackItem(title: String = "" , color:UIColor = "4A4A4A".color , font: UIFont = UIFont.appFont(weight: .light, size: 16), showBack:Bool = true , x: CGFloat = -20){
        
        // x: CGFloat = 15
        // hideBackWord()
        // x = -17
        //        self.navigationItem.leftItemsSupplementBackButton = true
        //        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 60 , height: 30))
        //        let label = UILabel()
        //        label.frame = CGRect.init(x: x, y: 4, width: ScreenSize.SCREEN_WIDTH - 65, height:25)
        //        label.text = title
        //        label.textColor = color
        //        label.font = font
        //        view.addSubview(label)
        //        view.sizeToFit()
        //        let backItem = UIBarButtonItem(customView: view)
        //        self.navigationItem.leftBarButtonItem = backItem
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = nil;
        
        let title = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        title.isEnabled = false
        title.setTitleTextAttributes([NSAttributedString.Key.font: font , NSAttributedString.Key.foregroundColor : color], for: .disabled)

        if showBack {
            let image = UIBarButtonItem(image: UIImage(named: "back-iconn"), style: .plain, target: self, action: #selector(goBack(sender:)))
            image.setTitleTextAttributes([NSAttributedString.Key.backgroundColor : UIColor.red], for: .disabled)
            self.navigationItem.leftBarButtonItems = [image,title]
        }else{
            self.navigationItem.leftBarButtonItems = [title]
        }
        self.navigationItem.leftItemsSupplementBackButton = false
    }
    
    @objc func goBack(sender: UIBarButtonItem){
        self.popVC()
    }
    
    //    @objc func goBack(sender: UIButton){
    //        self.popVC()
    //    }
    //
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
    func showMessageView(title:String ,msg: String){
        let msgView: CustomAlert = .fromNib()
        msgView.frame.size = CGSize(width: msgView.frame.width/1.3, height: 180)
        msgView.layer.cornerRadius = 8
        msgView.cancelBtn.isHidden = true
        let popup = KLCPopup()
        msgView.blockOk = {
            //            self.dismiss(animated: true, completion: nil)
            popup.dismiss(true)
            //            onOkClick()
        }
        popup.dismissType = KLCPopupDismissType.bounceOut
        popup.showType = KLCPopupShowType.bounceIn
        popup.contentView = msgView
        self.view.endEditing(true)
        popup.show()

    }
    
    func didFailedCallBack(_ error:NSError?){
        DispatchQueue.main.async { [weak self] in
            guard let wself = self else {return}
            Utl.ShowLoading(status: Hide, View: wself.view)
            Utl.ShowLoading2(status: Hide, View: wself.view)
            guard let error = error else {
                return
            }
            if error.code == 401{
                wself.setNavClear()
                Route.goCheckPhone()
            }
            Utl.ShowNotfication(Status: Failed, Body: error.domain)
        }
    }
    func handlerStatusResponse(status:Int?,errors:[String]?,message:String?) -> Bool{
        guard let status = status , status == 1 else {
            guard let errors = errors , !errors.isEmpty else{
                self.showErrorMessage(message: message ?? "nil")
                return false
            }
            let error_msg = errors.joined(separator: "\n")
            self.showErrorMessage(message: error_msg)
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
