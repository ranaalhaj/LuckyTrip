//
//  DestinationModel.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//
import Foundation


import Foundation


class ThumbnailModel: Codable{
    var image_type: String?
    var image_url: String?
 
    enum CodingKeys: String, CodingKey {
        case image_type = "image_type"
        case image_url = "image_url"
    }

    init(image_type: String,  image_url: String) {
        self.image_type = image_type
        self.image_url = image_url
    }

}

class DestinationVideoModel: Codable{
    var url: String?
    var thumbnail: ThumbnailModel?
 
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case thumbnail = "thumbnail"
    }

    init(url: String,  thumbnail: ThumbnailModel) {
        self.url = url
        self.thumbnail = thumbnail
    }

}


class MoreDetailsModel: Codable{
    var body: String?
 
    enum CodingKeys: String, CodingKey {
        case body = "text"
      
    }

    init(text: String,  image_url: String) {
        self.body = text
    }
}

class DestinationModel: Codable{
    var id: Int
    var city: String
    var country_name: String
    var country_code: String
    var thumbnail: ThumbnailModel?
    var destination_video: DestinationVideoModel?
    var description: MoreDetailsModel?
    var ischecked = false
 
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case city = "city"
        case country_name = "country_name"
        case country_code = "country_code"
        case thumbnail = "thumbnail"
        case destination_video = "destination_video"
        case description = "description"
    
    }

    init(id: Int, city: String, country_name: String , country_code: String, thumbnail: ThumbnailModel, descriptionObj: MoreDetailsModel, destination_videoObj : DestinationVideoModel) {
        self.id = id
        self.city = city
        self.country_name = country_name
        self.country_code = country_code
        self.description = descriptionObj
        self.destination_video = destination_videoObj
    
    }    

}


