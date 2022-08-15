//
//  Date.swift
//  UnitOneTemplate
//
//  Created by Sobhi Imad on 26/08/2021.
//

import Foundation
import UIKit

extension Date {

    var weekdayName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEEE"

        let lang = LanguageManager.currentLanguageCode()

        formatter.locale = Foundation.Locale(identifier: lang!) // Set For Arabic local code ar


        return formatter.string(from: self as Date)
    }


    func beginningOfDay() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }

    func endOfDay1() -> Date {
        var components = DateComponents()
        components.day = 1
        var date = (Calendar.current as NSCalendar).date(byAdding: components, to: self.beginningOfDay(), options: [])!
        date = date.addingTimeInterval(-1)
        return date
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return (Calendar.current as NSCalendar).date(byAdding: components, to: startOfDay, options: NSCalendar.Options())
    }


    func firstDayOfMonth () -> Date {
        let calendar = Calendar.current
        var dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        dateComponent.day = 1
        return calendar.date(from: dateComponent)!
    }

    func weekdayNameFromWeekdayNumber(_ weekdayNumber: Int) -> String {
        let calendar = Calendar.current
        let weekdaySymbols = calendar.weekdaySymbols
        let index = weekdayNumber + calendar.firstWeekday - 1
        return weekdaySymbols[index]
    }

    func dateByAddingMonths(_ months : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = months
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }

    func dateByAddingDays(_ days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }

    func hour() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.hour, from: self)
        return dateComponent.hour!
    }

    func second() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.second, from: self)
        return dateComponent.second!
    }

    func minute() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.minute, from: self)
        return dateComponent.minute!
    }

    func day() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.day, from: self)
        return dateComponent.day!
    }

    func weekday() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.weekday, from: self)
        return dateComponent.weekday!
    }

    func month() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.month, from: self)
        return dateComponent.month!
    }

    func year() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.year, from: self)
        return dateComponent.year!
    }

    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let days = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return days.length
    }

    func dateByIgnoringTime() -> Date {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        return calendar.date(from: dateComponent)!
    }

    func monthNameFull() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: self)
    }

    func isSunday() -> Bool
    {
        return (self.getWeekday() == 1)
    }

    func isMonday() -> Bool
    {
        return (self.getWeekday() == 2)
    }

    func isTuesday() -> Bool
    {
        return (self.getWeekday() == 3)
    }

    func isWednesday() -> Bool
    {
        return (self.getWeekday() == 4)
    }

    func isThursday() -> Bool
    {
        return (self.getWeekday() == 5)
    }

    func isFriday() -> Bool
    {
        return (self.getWeekday() == 6)
    }

    func isSaturday() -> Bool
    {
        return (self.getWeekday() == 7)
    }




    func getWeekday() -> Int {
        let calendar = Calendar.current
        return (calendar as NSCalendar).components( .weekday, from: self).weekday!
    }

    func isToday() -> Bool {
        return self.isDateSameDay(Date())
    }

    func isDateSameDay(_ date: Date) -> Bool {

        return (self.day() == date.day()) && (self.month() == date.month() && (self.year() == date.year()))

    }

    func differenceBetweenTime (_ enddt:Date)->Int {

        let calendar = Calendar.current
        let datecomponenets = (calendar as NSCalendar).components(.hour, from: self, to: enddt, options: [])
        return  datecomponenets.hour!

    }

    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }

    func ToLocalStringWithFormat(_ dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let timeStamp = dateFormatter.string(from: self)

        return timeStamp
    }

    func toLocalTime()->Date {

        let tz = TimeZone.autoupdatingCurrent
        let seconds = tz.secondsFromGMT(for: self)
        let myDouble = NSNumber(value: seconds as Int)
        let myTimeInterval = TimeInterval(myDouble.doubleValue)
        return Date(timeInterval: myTimeInterval , since: self)

    }

    func toGlobalTime()->Date {

        let tz = TimeZone.autoupdatingCurrent
        let seconds = -tz.secondsFromGMT(for: self)
        let myDouble = NSNumber(value: seconds as Int)
        let myTimeInterval = TimeInterval(myDouble.doubleValue)
        return Date(timeInterval: myTimeInterval , since: self)

    }
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

