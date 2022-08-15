//
//  FirebaseSubscriptions.swift
//  RoyaTV
//
//  Created by Tareq Mohammad on 2/23/22.
//

import Foundation
import Firebase
class FirebaseSubscription{
    
    static let shared = FirebaseSubscription()
    
    var age = 0
     func addFirebaseTopics(logout:Bool){
         
        var currentUser = CredentialNewUser()
         var countryCode = currentUser.country_code
         let date = Date()
         let calendar = Calendar.current

         let year = calendar.component(.year, from: date)

        guard let data = DataSocial.retoreFromUserDefaults(byKey: AppConstants.KeyUserObject) else { return}
        guard let user = data.user else { return}
         guard let fullNameArr = user.date_of_birth?.components(separatedBy: "-"),var year : Int = Int(fullNameArr[0]), var gender = user.gender else { return}
         age =  calculateAge(birthDate: year)

         
        Messaging.messaging().subscribe(toTopic: "device_id_2") { error in
            if error != nil {
            print(error?.localizedDescription)
            }
            print("deivce_id_2,subscripe")
        }
        
        if currentUser.country_code != ""{
            print(currentUser.country_code)
            Messaging.messaging().subscribe(toTopic: "\(countryCode)") { error in
                if error != nil {
            print(error?.localizedDescription)
                }
                print("country_code,subscripe")
            }
        }
        
        if !logout{
            if isGuest(){
                Messaging.messaging().subscribe(toTopic: "guest") { error in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    print("subscribe,guest")
                }
            }else{
                if gender == "" {
                    gender = "Female"
                }
                Messaging.messaging().subscribe(toTopic: "\(gender)") { error in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    print("subscribe,deivce_id_2")
                }
                if age == 0{
                    age = 1900
                }
                
                Messaging.messaging().subscribe(toTopic: "\(age)") { error in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    print("subscribe,deivce_id_2")
                }
                Messaging.messaging().unsubscribe(fromTopic: "guest_2") { error in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    print("subscribe,deivce_id_2")
                }
            }
         
        }else{
            Messaging.messaging().subscribe(toTopic: "guest") { error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                print("subscribe,guest")
            }
            if gender == "" {
                gender = "Female"
            }
            Messaging.messaging().unsubscribe(fromTopic: "\(gender)") { error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                print("subscribe,deivce_id_2")
            }
            if age == 0{
               age = 1900
            }
            Messaging.messaging().unsubscribe(fromTopic: "\(age)") { error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                print("subscribe,deivce_id_2")
            }
        }

        }
    func calculateAge(birthDate : Int) -> Int{
        let date = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        return year - birthDate
    }
}


