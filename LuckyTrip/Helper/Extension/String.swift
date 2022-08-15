//
//  String.swift
//  iOSTemplate

//

import Foundation
import  UIKit
extension String {
    
    
    var hex: Int? {
        return Int(self, radix: 16)
    }
    
    var color: UIColor {
        let hex = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    func clearWhiteSpace() ->String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func encodeUTF8() -> String? {
        
        //If I can create an NSURL out of the string nothing is wrong with it
        if let _ = URL(string: self) {
            
            return self
        }
        
        //Get the last component from the string this will return subSequence
        let optionalLastComponent = self.split { $0 == "/" }.last
        
        
        if let lastComponent = optionalLastComponent {
            
            //Get the string from the sub sequence by mapping the characters to [String] then reduce the array to String
            let lastComponentAsString = lastComponent.map { String($0) }.reduce("", +)
            
            
            //Get the range of the last component
            if let rangeOfLastComponent = self.range(of: lastComponentAsString) {
                //Get the string without its last component
                let stringWithoutLastComponent = self.substring(to: rangeOfLastComponent.lowerBound)
                
                
                //Encode the last component
                if let lastComponentEncoded = lastComponentAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) {
                    
                    
                    //Finally append the original string (without its last component) to the encoded part (encoded last component)
                    let encodedString = stringWithoutLastComponent + lastComponentEncoded
                    
                    //Return the string (original string/encoded string)
                    return encodedString
                }
            }
        }
        
        return nil;
    }

    var htmlToAttributedString: NSAttributedString? {
        var attribStr = NSMutableAttributedString()
        do {//, allowLossyConversion: true
            attribStr = try NSMutableAttributedString(data: self.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let textRangeForFont : NSRange = NSMakeRange(0, attribStr.length)
            attribStr.addAttributes([NSAttributedString.Key.font : UIFont.appFont(weight: .light, size: 18)], range: textRangeForFont)
            
        } catch {
            print(error)
        }
        
        return attribStr
    }
    
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func htmlDecoded()->String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        
        let entities = [
            "&quot;"    : "\"",
            "&ldquo;"   : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&nbsp;"    : "\n",
            
            
            
        ]
        
        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
    
    
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil
            
        }
    }
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespaces)
            return trimmed.isEmpty
        }
    }
    
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern:"[A-Z0-9a-z._%+-]{2,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func changeToEnglishNumber()->String{
        
        let NumberStr: String = self
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = Locale(identifier: "EN")
        let final = Formatter.number(from: NumberStr)
        return final?.stringValue ?? ""
    }
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
        var filtered:String!
        
        let inputString:[String] = self.components(separatedBy: charcter)
        filtered = inputString.joined(separator: "") as String
        return  self == filtered
        
    }
    func replace_fromStart(str:String , endIndex:Int , With:String) -> String {
        var strReplaced = str ;
        let start = str.startIndex;
        let end = str.index(str.startIndex, offsetBy: endIndex);
        strReplaced = str.replacingCharacters(in: start..<end, with: With) ;
        return strReplaced;
    }
    
    //    func isNumeric() -> Bool
    //    {
    //        let scanner = Scanner(string: self)
    //
    //        // A newly-created scanner has no locale by default.
    //        // We'll set our scanner's locale to the user's locale
    //        // so that it recognizes the decimal separator that
    //        // the user expects (for example, in North America,
    //        // "." is the decimal separator, while in many parts
    //        // of Europe, "," is used).
    //        scanner.locale = Foundation.Locale.current
    //
    //        return scanner.scanDecimal(nil) && scanner.isAtEnd
    //    }
    //
    //    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
    //        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    //
    //        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    //
    //        return boundingBox.height
    //    }
    func pathExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    func toDate(_ defaultFormat: String = "dd/MM/yyyy HH:mm:ss") -> Date {
        
        let toDate = DateFormatter()
        toDate.dateFormat = defaultFormat
        toDate.locale = Locale(identifier: "en")
        let newDate = toDate.date(from: self)
        return newDate ?? Date()
    }
    
    var addPercentEncoding:String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    public func stringByAddingPercentEncodingToData() -> String? {
        let finalString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: "&", with: "%26").replacingOccurrences(of: "+", with: "%2B")
        return finalString
    }
    var urlEncoded: String {
        var charset: CharacterSet = .urlQueryAllowed
        charset.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        return self.addingPercentEncoding(withAllowedCharacters: charset)!
    }

    public func stringByAddingPercentEncodingToData() -> String {
        let encodedPlus = self.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)
        return encodedPlus!
    }
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)

        if plusForSpace {
            allowed.addCharacters(in: " ")
        }

        var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }
        return encoded
    }

    

    var toDouble:Double{
        return Double(self)!
    }
    var toInt:Int{
        return Int(self)!
    }
    var toData:Data{
        return Data(self.utf8)
    }
    func getWidth(font:UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: font])
    }
//    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//
//        return boundingBox.width
//    }

    
    /**
     Converts a string of format HH:mm:ss into seconds
     ### Expected string format ###
     ````
        HH:mm:ss or mm:ss
     ````
     ### Usage ###
     ````
        let string = "1:10:02"
        let seconds = string.inSeconds  // Output: 4202
     ````
     - Returns: Seconds in Int or if conversion is impossible, 0
     */
    var inSeconds : Int {
        var total = 0
        let secondRatio = [1, 60, 3600]    // ss:mm:HH
        for (i, item) in self.components(separatedBy: ":").reversed().enumerated() {
            if i >= secondRatio.count { break }
            total = total + (Int(item) ?? 0) * secondRatio[i]
        }
        return total
    }
    
    func encodeUrl() -> URL? {
        if let linkWithPercentEscapes =  self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: linkWithPercentEscapes) {
            return url
        }
        return nil
    }
}

extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}

