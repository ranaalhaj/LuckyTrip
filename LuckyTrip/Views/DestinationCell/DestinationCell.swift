//
//  DestinationCell.swift
//
//  Created by Rana Alhaj
//

import UIKit


protocol CheckedDelegate{
    func checkClicked(index: Int, isChecked: Int)
}


class DestinationCell: UICollectionViewCell {

    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var checkboxBtn: UIButton!
    var delegate: CheckedDelegate?
    var destination : DestinationModel?
    var index : Int! = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func checkBoxChangedValue(_ sender: UIButton) {
        let tag = sender.tag
        self.checkboxBtn.tag = (tag == 0) ? 1 : 0
        
        if let image = UIImage(named: (self.checkboxBtn.tag == 1) ? "checkbox_selected" : "checkbox_unselected") {
            self.checkboxBtn.setImage(image, for: .normal)
        }
        
        delegate?.checkClicked(index: index!, isChecked: self.checkboxBtn.tag )
    }
}
