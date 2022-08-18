//
//  DestinationCell.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//
import UIKit
import Moya


protocol SelectedItemsDelegate{
    func playButtonClicked(destination: DestinationModel)
    func deleteButtonClicked(index: Int)
}


class DestinationCell: UICollectionViewCell {
    //MARK:  DECLERATIONS
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var checkboxBtn: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: SelectedItemsDelegate?
    var destination : DestinationModel?
    var index : Int! = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK:  FILL DATA
    func fillCellValuesWithDefultDest(destination currentDest: DestinationModel, mode: Int){
        self.destination = currentDest
        self.cityName.text = currentDest.city
        self.countryName.text = currentDest.country_name
        

        self.thumbnailImage.setImageKF(imageLink: currentDest.thumbnail?.image_url, placholder: "thumbnail_image")
       
        if (self.thumbnailImage.image == nil)
        {
            self.thumbnailImage.image = UIImage.init(named: "thumbnail_image")
        }
        
        if (currentDest.destination_video == nil) {
            self.playButton.isHidden = true
        }else{
            self.playButton.isHidden = false
        }
      
        if (mode  == ListModeType.select.rawValue){
            self.checkboxBtn.isHidden = false
        }else{
            self.checkboxBtn.isHidden = true
        }
        
        if let image = UIImage(named: (currentDest.ischecked == false) ? "checkbox_unselected" : "checkbox_selected" ) {
            self.checkboxBtn.setImage(image, for: .normal)
        }
        
        self.deleteButton.isHidden = true
    }
    
    
    
    //MARK:  FILL DATA
    func fillCellValuesWithSavedDest(destination currentDest: SavedDestinations, index : Int){
        self.destination = nil
        self.index = index
        self.cityName.text = currentDest.city
        self.countryName.text = currentDest.country_name
        
        self.thumbnailImage.setImageKF(imageLink: currentDest.thumbnailImage, placholder: "thumbnail_image")
       
        if (self.thumbnailImage.image == nil)
        {
            self.thumbnailImage.image = UIImage.init(named: "thumbnail_image")
        }
             
        self.playButton.isHidden = (currentDest.isVideo == 0)  ? true : false
      
        self.checkboxBtn.isHidden = true
        self.deleteButton.isHidden = false
    }
    
    
    //MARK:  ACTIONS
    @IBAction func checkBoxChangedValue(_ sender: UIButton) {
      
        self.destination?.ischecked  = !(self.destination?.ischecked ?? false)
    
        if let image = UIImage(named: (self.destination?.ischecked == false) ? "checkbox_unselected" : "checkbox_selected") {
            self.checkboxBtn.setImage(image, for: .normal)
        }
    }
    
    
    @IBAction func playClicked(_ sender: UIButton) {
        if (self.destination != nil){
            delegate?.playButtonClicked(destination: self.destination!)
        }
    }
    
    @IBAction func deleteClicked(_ sender: UIButton) {
        delegate?.deleteButtonClicked(index: self.index!)
    }
    
}
