//
//  DestinationsViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 14/08/2022.
//

import UIKit

class DestinationDetailsViewController: UIViewController {
    
    
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
        if destination.thumbnail?.image_type ?? ""  == "thumbnail"{
            self.playIcon.isHidden = true
        }else{
            self.playIcon.isHidden = false
        }
        
        self.cityName.text = destination.city
        self.countryName.text = destination.country_name
        self.fullDescription.text = destination.description?.text ?? ""
    }
    
}
