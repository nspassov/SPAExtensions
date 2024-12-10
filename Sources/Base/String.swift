import Foundation

public extension String {
    func isValidEmail() -> Bool {
        guard !self.lowercased().hasPrefix("mailto:") else {
            return false
        }
        guard let emailDetector
            = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let matches
            = emailDetector.matches(in: self,
                                    options: NSRegularExpression.MatchingOptions.anchored,
                                    range: NSRange(location: 0, length: self.count))
        guard matches.count == 1 else {
            return false
        }
        return matches[0].url?.scheme == "mailto"
    }
    
    func formURLEncodedString() -> String {
        var characterSet = NSCharacterSet.urlHostAllowed
        characterSet.formUnion(CharacterSet(charactersIn: " "))
        if let s = addingPercentEncoding(withAllowedCharacters: characterSet) {
            return s.replacingOccurrences(of: " ", with: "+")
        }
        return ""
    }
    
    func capitalizedSentence() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

public enum Localized: Sendable {
    public static func string(_ key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: "")
    }
}

public extension String {
    func passThrough(_ condition: @escaping(Self)->(Bool)) -> Self? {
        return condition(self) ? self : nil
    }
}

public extension Sequence {
    func passThrough(_ condition: @escaping(Self)->(Bool)) -> Self? {
        return condition(self) ? self : nil
    }
}
