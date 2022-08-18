//
//  BaseViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  This Class is the parent for all viewcontrollers... here we can handle the common components and functions such as set UINavigationbar appearence

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    //MARK:  DECLERATIONS
    let Utl = Utilities()
    
    private var observer: NSObjectProtocol!
    
    
    var hud = MBProgressHUD()
    fileprivate var aView :UIView?
    var ai = UIActivityIndicatorView(style: .medium)
    
    
    //MARK:  FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    func customUI(){
        self.view.backgroundColor = .white
    }
    
    
    func ShowLoading(status:String,View: UIView){
        removeSpinner()
        if(status == "Show"){
            aView = UIView(frame: View.bounds)
            aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
            ai.center = aView!.center
            aView?.tintColor = .gray
            ai.startAnimating()
            aView!.addSubview(ai)
            View.addSubview(aView!)
  
        }else{
            removeSpinner()
        }
    }
    private func removeSpinner(){
        ai.stopAnimating()
        aView?.removeFromSuperview()
        aView = nil
    }
    
}
