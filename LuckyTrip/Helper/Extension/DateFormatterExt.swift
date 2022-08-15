//
//  DateFormatterExt.swift
//  Avon Sales
//
//  Created by Ikhlas on 1/18/21.
//  Copyright © 2021 sobhi. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func timeSince(from: Date, numericDates: Bool = false) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(from as Date)
        let latest = earliest == now ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second],
                                                 from: earliest, to: latest)
        
        let year       = components.year ?? 0
        let month      = components.month ?? 0
        let week       = components.weekOfYear ?? 0
        let day        = components.day ?? 0
        let hour       = components.hour ?? 0
        let minute     = components.minute ?? 0
        let second     = components.second ?? 0
        
        if from > now {
            return ""
        }
        
        if (year >= 2) {
            return "\(year)" + " " + "years".localized + " " + "ago".localized
        } else if (year >= 1){
            if (numericDates){
                return "1" + " " + "year".localized + " " + "ago".localized
            } else {
                return "last year".localized
            }
        } else if (month >= 2) {
            return "\(month)" + " " + "months".localized + " " + "ago".localized
        } else if (month >= 1){
            if (numericDates){
                return "1" + " " + "month".localized + " " + "ago".localized
            } else {
                return "Last month".localized
            }
        } else if (week >= 2) {
            return "\(week)" + " " + "weeks".localized + " " + "ago".localized
        } else if (week >= 1){
            if (numericDates){
                return "1" + " " + "week".localized + " " + "ago".localized
            } else {
                return "Last week".localized
            }
        } else if (day >= 2) {
            return "\(day)" + " " + "days".localized + " " + "ago".localized
        } else if (day >= 1){
            if (numericDates){
                return "1" + " " + "day".localized + " " +  "ago".localized
            } else {
                return "yesterday".localized
            }
        } else if (hour >= 2) {
            return "\(hour)" + " "  + "hours".localized + " "  + "ago".localized
        } else if (hour >= 1){
            if (numericDates){
                return "1" + " " + "hour".localized + " " + "ago".localized
            } else {
                return "An hour ago".localized
            }
        } else if (minute >= 2) {
            return "\(minute)"  + " " + "minutes".localized + " " + "ago".localized
        } else if (minute >= 1){
            if (numericDates){
                return "1" + " " + "minute".localized + " " + "ago".localized
            } else {
                return "A minute ago".localized
            }
        } else if (second >= 3) {
            return "\(second)" + " " + "seconds".localized + " " + "ago".localized
        } else {
            return "Just now".localized
        }
    }
}
