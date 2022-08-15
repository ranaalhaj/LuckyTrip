//
//  HistoryEpisodes.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/28/21.
//

import Foundation
import UIKit

struct Auth_User {
    
    static func saveEposideLocal(_ item: EpisodesHistory){
        if let index = EpisodeItems.firstIndex(where: {$0.episode_id == item.episode_id}){
            EpisodeItems[index] = item
        }else {
            EpisodeItems.append(item)
        }
    }

    static var EpisodeItems: [EpisodesHistory] {
        get {
            let ud = UserDefaults.standard
            if let storedObject: Data = ud.object(forKey: "EpisodeItems") as? Data {
                return try! PropertyListDecoder().decode([EpisodesHistory].self, from: storedObject)
            }
            return []
        }
        set(userinfo) {
            let ud = UserDefaults.standard
            ud.set(try! PropertyListEncoder().encode(userinfo), forKey: "EpisodeItems")
        }
    }
    
    static var ItemsCount : Int {
        return EpisodeItems.count
    }
    
    static var IsFirstTime: Bool {
        get {
            let ud = UserDefaults.standard
            return ud.value(forKey: "IsFirstTime") as? Bool ?? true
        }
        set(token) {
            let ud = UserDefaults.standard
            ud.set(token, forKey: "IsFirstTime")
        }
    }
}

