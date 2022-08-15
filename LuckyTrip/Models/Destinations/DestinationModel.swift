//
//  DestinationModel.swift
//
//  Created by Rana Alhaj
//


import Foundation

struct DestinationModel: Codable{
    var id: Int?
    var city: String?
    var airport_name: String?
    var country_name: String?
    var country_code: String?
    var thumbnail: Thumbnail?
    var description : Description?
}

struct Thumbnail: Codable{
    var image_type: String?
    var image_url: String?
 
}


struct Description : Codable {
    var text: String?
}
/*
 "id": 329,
 "city": "A Coruña",
 "country_name": "Spain",
 "airport_name": "A Coruña",
 "country_code": "ES",
 "latitude": 43.302372,
 "longitude": -8.380096,
 "iata_code": "LCG",
 "iata_parent_id": 0,
 "is_enabled": "yes",
 "temperature": 0,
 "original_destination_id": 329,
 "thumbnail": {
   "image_type": "thumbnail",
   "image_url": "https://devapi.luckytrip.co.uk/images/destinations/329.jpg"
 },
 "description": {
   "id": 9414,
   "object_id": 329,
   "object_type": "destination",
   "description_type": "description",
   "text": "\"La Coruña is one long e-sea front...\" says Ramon your taxi driver with a Cheshire cat grin. \r\n\r\nSurfers wax their boards on sprawling urban beaches and sip cold cans of Estrella Galicia. Then they head inland to tapas bars selling grilled octopus and cheese ice cream (que?) and spend nights out on seaside terraces. \r\n\r\nCheck out Pablo Picasso’s old gaff and the first ever ‘Zara’ store in Orzán. This salty harbour city is a Spanish Brighton (minus the pebbles…)",
   "language_code": "en",
   "translated": 1
 },
 "destination_images": [],
 */


/*
 
 "id": 1366,
 "object_id": 320,
 "object_type": "destination",
 "description_type": "description",
 "text": "Italy’s dark horse. \r\n\r\nThe ‘toe of the boot’ has a bad rep thanks to mafia antics and earthquakes but with miles of unspoilt beaches, remote national parks and rural adventure, Calabria gives Italy edge. \r\n\r\nCrumbling cliffs and coastal villages meet vibrant towns and spicy cuisine (it’s all about the big bad chilli pepper). \r\n\r\nGet there before Thompson does. ",
 "language_code": "en",
 "translated": 1,
 */
