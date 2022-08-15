//
//  CheckBox.swift
//  Viviane
//
//  Created by Ikhlas on 5/6/21.
//

import UIKit

class CheckBox: UIButton {

    var is_select : Bool = false { didSet { setSelected() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
        
        ///set default style
        setSelected()
    }

    private func config(){
        ///add space between image and title
        //if LanguageManager.isCurrentLanguageRTL() {
            titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        //}else {
            //titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        //}
    }
    
    private func setSelected(){
        let img = is_select ? UIImage(named: "check-icon") : UIImage(named: "unCheck-icon")
        setImage(img, for: .normal)
    }
}
