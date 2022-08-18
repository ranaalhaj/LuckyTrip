//
//  DestinationDetailsViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  This Class is to display more details about the selected destinations

import UIKit

class DestinationDetailsViewController: BaseViewController {
    
    
    var destination: DestinationModel!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var fullDescription: UITextView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    
   override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
    }
    
    func fillData(){
        
        self.thumbnailImage.setImageKF(imageLink: destination.thumbnail?.image_url)
        
        if (self.thumbnailImage.image == nil)
        {
            self.thumbnailImage.image = UIImage.init(named: "thumbnail_image")
        }
        
       
        self.playIcon.isHidden = (destination.destination_video == nil) ? true : false
        
        
        self.cityName.text = destination.city
        self.countryName.text = destination.country_name
        self.fullDescription.text = destination.description?.body ?? ""
    }
    
}
