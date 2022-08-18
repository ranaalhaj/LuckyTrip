//
//  UIImageView.swift


import UIKit
import Kingfisher
import SDWebImage
import KingfisherWebP

extension UIImageView{
        func setImageKF(imageLink:String?,placholder:String = "placeholder"){

            guard let imageURL = URL(string: imageLink ?? "") else {
                return
            }
            self.kf.indicatorType = .activity
            self.kf.setImage(with: imageURL, options: [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)])
            

            
        }
}
