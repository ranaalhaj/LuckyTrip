//
//  UIExtensions.swift
//
//  Created by Rana Alhaj on 14/8/22.
//  Copyright © 2022 ranaalhaj. All rights reserved.
//


import UIKit

public extension UIView {
    
/*    static func applyAppFont(forView view : UIView){
        let systemFont : UIFont!
        
        if let lb = view as? UILabel {
            systemFont = UIFont.systemFont(ofSize: 12, weight: lb.font.weight)
            if(systemFont.fontName == lb.font.fontName){
                lb.font = UIFont.appFont(weight: lb.font.weight, size: lb.font.pointSize)
            }
        }else if let txtF = view as? UITextField{
            systemFont = UIFont.systemFont(ofSize: 12, weight: txtF.font?.weight ?? .regular)
            if let font = txtF.font, font.fontName == systemFont.fontName{
                txtF.font = UIFont.appFont(weight: font.weight,
                                           size: font.pointSize)
            }
        }else if let txtV = view as? UITextView {
            systemFont = UIFont.systemFont(ofSize: 12, weight: txtV.font?.weight ?? .regular)
            if let font = txtV.font, font.fontName == systemFont.fontName{
                txtV.font = UIFont.appFont(weight: font.weight,
                                           size: font.pointSize)
            }
        }else if let btn = view as? UIButton {
            systemFont = UIFont.systemFont(ofSize: 12, weight: btn.titleLabel?.font.weight ?? .regular)
            if let font = btn.titleLabel?.font, font.fontName == systemFont.fontName{
                btn.titleLabel?.font = UIFont.appFont(weight: font.weight,
                                                      size: font.pointSize)
            }
        }
    }
    func applyAppFont(){
        UIView.applyAppFont(forView: self)
    }
    
    //Methods Swizzling
    static let Init: Void = {
        let originalMethod = class_getInstanceMethod(UIView.self, #selector(awakeFromNib))
        let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(_awakeFromNib))
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            // switch implementation..
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    @objc func _awakeFromNib() {
        self.applyAppFont()
    }
    //End Method Swizzling
    */
}


public extension UIFont {
    
    static var appFonts : [UIFont.Weight: String] = [:]
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }
    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }
    
    
    static func appFont(weight: UIFont.Weight, size: CGFloat)->UIFont{
        //if let fontsConfigsPath = Bundle.main.path(forResource: "FontsConfig", ofType: "plist") {
        //    let appFonts : [String:String] = (NSDictionary(contentsOfFile: fontsConfigsPath) as? [String:String]) ?? [:]
        
        if let fontName = appFonts[weight] ?? appFonts[.regular] {
            return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        }
        //}
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}

public extension UIViewController {
    
    @IBAction func backAction(_ sender : Any?) {
        if let navigation = self.navigationController {
            if navigation.viewControllers.count > 1 {
                navigation.popViewController(animated: true)
                return
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

  
}



//extension UIView {
//    
//    @IBOutlet weak var leadingConstraint : NSLayoutConstraint?{
//        set(value){
//            
////            if(value?.firstAttribute != .leading){
////                Swift.print("Trying to assign not leading constaint to leading constraint")
////            }
//            
//            objc_setAssociatedObject(self, &AssociatedKeys.leadingKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            
//        }
//        get{
//            return objc_getAssociatedObject(self, &AssociatedKeys.leadingKey) as? NSLayoutConstraint
//        }
//    }
//    
//       @IBOutlet weak var trailingConstraint : NSLayoutConstraint?{
//           set(value){
//               objc_setAssociatedObject(self, &AssociatedKeys.trailingKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//               
//           }
//           get{
//               return objc_getAssociatedObject(self, &AssociatedKeys.trailingKey) as? NSLayoutConstraint
//           }
//       }
//    
//       @IBOutlet weak var topConstraint : NSLayoutConstraint?{
//           set(value){
//               objc_setAssociatedObject(self, &AssociatedKeys.topKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//               
//           }
//           get{
//               return objc_getAssociatedObject(self, &AssociatedKeys.topKey) as? NSLayoutConstraint
//           }
//       }
//    
//       @IBOutlet weak var bottomConstraint : NSLayoutConstraint?{
//           set(value){
//               objc_setAssociatedObject(self, &AssociatedKeys.bottomKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//               
//           }
//           get{
//               return objc_getAssociatedObject(self, &AssociatedKeys.bottomKey) as? NSLayoutConstraint
//           }
//       }
//    
//       @IBOutlet weak var centerXConstraint : NSLayoutConstraint?{
//           set(value){
//               objc_setAssociatedObject(self, &AssociatedKeys.centerXKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//               
//           }
//           get{
//               return objc_getAssociatedObject(self, &AssociatedKeys.centerXKey) as? NSLayoutConstraint
//           }
//       }
//    
//       @IBOutlet weak var centerYConstraint : NSLayoutConstraint?{
//           set(value){
//               objc_setAssociatedObject(self, &AssociatedKeys.centerYKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//               
//           }
//           get{
//               return objc_getAssociatedObject(self, &AssociatedKeys.centerYKey) as? NSLayoutConstraint
//           }
//       }
//    
//       @IBOutlet weak var heightConstraint : NSLayoutConstraint?{
//           set(value){
//               objc_setAssociatedObject(self, &AssociatedKeys.heightKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//               
//           }
//           get{
//               return objc_getAssociatedObject(self, &AssociatedKeys.heightKey) as? NSLayoutConstraint
//           }
//       }
//    
//       @IBOutlet weak var widthConstraint : NSLayoutConstraint?{
//           set(value){
//               objc_setAssociatedObject(self, &AssociatedKeys.widthKey, value,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//               
//           }
//           get{
//               return objc_getAssociatedObject(self, &AssociatedKeys.widthKey) as? NSLayoutConstraint
//           }
//       }
//}


extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
}

extension NSLayoutConstraint {
    
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        guard let fitem = self.firstItem else {return self}        
        return NSLayoutConstraint(item: fitem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
