import UIKit
import Foundation
import SystemConfiguration
import MBProgressHUD
//import ActionSheetPicker_3_0
import SwiftMessages
class Utilities: NSObject {
    
 
    func isValidJson(text: String) -> Bool{
        if let data = text.data(using: .utf8) {
            do {
                let data =  try JSONSerialization.jsonObject(with: data, options: [])
                //            print("JSONSerializationJSONSerializationJSONSerialization")
                //            print(data)
                return true
            } catch {
                print(error.localizedDescription)
            }
        }
        return false
    }
    
    
    var hud = MBProgressHUD()
    var hud2 = MBProgressHUD()
    fileprivate var aView :UIView?
    var ai = UIActivityIndicatorView(style: .whiteLarge)
    var viewSwiftMessage : MessageView?

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
    func ShowLoading2(status:String,View: UIView){
        removeSpinner()
        if(status == "Show"){
            aView = UIView(frame: View.bounds)
            aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
            ai.center = aView!.center
            ai.startAnimating()
            aView!.addSubview(ai)
            View.addSubview(aView!)
  
        }else{
            removeSpinner()
        }
    }

    
    func ShowLoadingData(status:String,View: UIView){
        removeSpinner()
        if(status == "Show"){
            // mohammad lutfi edit -> edite loader
            aView = UIView(frame: View.bounds)
            aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
            ai.center = aView!.center
            ai.startAnimating()
            aView!.addSubview(ai)
            View.addSubview(aView!)
  
        }else{
            removeSpinner()
        }
    }
    func ShowNotfication(Status:String,Body:String)
    {

        SwiftMessages.hideAll()
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.success)
        view.iconImageView?.isHidden = true
        view.button?.isHidden = true
        view.backgroundView.backgroundColor = .clear
        view.bodyLabel?.font = UIFont.appFont(weight: .bold, size: 14.0)
        view.titleLabel?.textAlignment = .center
        view.bodyLabel?.textAlignment = .center
        view.titleLabel?.isHidden = true
        var BGColor = UIColor()
        
        if(Status == "Success".localized)
        {
            BGColor = .systemGreen
        }else
        {
            BGColor = .systemRed
        }
        
        view.backgroundColor = BGColor
        view.configureContent(title: Status , body: Body)
        
        SwiftMessages.show(view: view)
    }
    func setNSAttributedString(firstText:String,secondText:String) -> NSAttributedString{
        let mutableAttributedString = NSMutableAttributedString()
        let attrreg = [NSAttributedString.Key.font:UIFont.appFont(weight: .regular, size: 14.0)]
        let attrbold = [NSAttributedString.Key.font:UIFont.appFont(weight: .bold, size: 16.0)]
        mutableAttributedString.append(NSAttributedString(string: firstText, attributes: attrreg))
        mutableAttributedString.append(NSAttributedString(string: secondText, attributes: attrbold))
        return mutableAttributedString
    }
    
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }
    
    func  isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    func getDeviceModel()->String
    {
        return [UIDevice.current.model,UIDevice.current.systemVersion].compactMap({$0}).joined(separator: ",")
    }
    func getDeviceName() ->String{
        return UIDevice.current.name
    }
    func getDeviceUDID() -> String{
        var udid :String = "no_uuid"
        if let UDID =  UIDevice.current.identifierForVendor?.uuidString{
            udid =  UDID
        }
        return udid

    }
 
 
   


enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

}
extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        switch(vc){
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            break;
            
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            break;
            
        default:
            if let presentedViewController = vc.presentedViewController {
                //print(presentedViewController)
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                }
                else{
                    return vc;
                }
            }
            else{
                return vc;
            }
            break;
        }
        
    }
    
}

extension UIButton{
    
    func DrawShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        //        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
        //        self.clipsToBounds = true
    }
}

extension UIView{
    
    func DrawShadow_() {
        self.layer.shadowColor = UIColor(red:0.57, green:0.65, blue:0.64, alpha:0.50).cgColor
        //        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 8.0
        self.layer.masksToBounds = false
        //        self.clipsToBounds = true
    }
}

//conver date format to  "MMM d, h:mm a"
func convertDateFormat(_ dateString: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US")
    
    let dateObj = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "dd/MM/yyyy" //"d MMM, yyyy, h:mm a "
    
    print("Dateobj: \(dateFormatter.string(from: dateObj ?? Date()))")
    
    if let date_ =  dateObj {
        return dateFormatter.string(from: date_)
    }else {
        return dateString
    }
}


func getBarButton(_ title : String) -> UIBarButtonItem{
    let customButton =  UIButton.init(type: UIButton.ButtonType.custom)
    customButton.setTitle(title, for: .normal)
    //        customButton.roundCorner(5)
    customButton.setTitleColor( UIColor(red:0.33, green:0.61, blue:0.92, alpha:1.00)  , for: .normal)
    customButton.frame = CGRect.init(x: 0, y: 5, width: 80, height: 32)
    customButton.backgroundColor = .clear
    
    return UIBarButtonItem.init(customView: customButton)
}


extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
}



//func getAttributedText(_ firstString : String , firstStingFont : UIFont, secondString : String , secStingFont : UIFont , firstColor : UIColor , secColor : UIColor )  -> NSAttributedString {
//
//    let firstStringAttribute = [NSAttributedString.Key.foregroundColor: firstColor  , NSAttributedString.Key.font:   firstStingFont ]
//
//    let secondeStringAttribute = [NSAttributedString.Key.foregroundColor: secColor  , NSAttributedString.Key.font: secStingFont  ]
//
//    let firstMutableAttributedString = NSMutableAttributedString(string:  firstString   , attributes: firstStringAttribute)
//
//    let secondMutableAttributedString = NSMutableAttributedString(string:  secondString   , attributes: secondeStringAttribute)
//
//    return firstMutableAttributedString + secondMutableAttributedString
//
//}






