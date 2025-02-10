import Foundation

extension NSDecimalNumber {
    
    private static let formatter = NumberFormatter()
    
    func toString(locale: Locale) -> String {
        Self.formatter.locale = locale
        Self.formatter.numberStyle = .decimal
        Self.formatter.maximumFractionDigits = 2
        Self.formatter.minimumFractionDigits = 2
        return Self.formatter.string(from: self) ?? ""
    }
    
    static func from(string: String, locale: Locale) -> NSDecimalNumber? {
        guard !string.isEmpty else {
            return NSDecimalNumber.zero
        }
        Self.formatter.locale = locale
        Self.formatter.numberStyle = .decimal
        Self.formatter.maximumFractionDigits = 2
        Self.formatter.minimumFractionDigits = 2
        if let number = Self.formatter.number(from: string) {
            return NSDecimalNumber.init(decimal: number.decimalValue)
        }
        return nil
    }
}
