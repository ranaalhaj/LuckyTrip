//
//  UIImageView.swift


import UIKit
import Kingfisher
import SDWebImage
import KingfisherWebP

extension UIImageView{
        func setImageKF(imageLink:String?,placholder:String = "placeholder"){

            guard let imageURL = URL(string: imageLink ?? "") else {
                //self.image = UIImage(named: placholder)
                return
            }
//            print("imageURL",imageURL)
            self.kf.indicatorType = .activity
            
            //self.kf.setImage(with: imageURL )
            self.kf.setImage(with: imageURL, options: [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)])
            

            
        }
}
