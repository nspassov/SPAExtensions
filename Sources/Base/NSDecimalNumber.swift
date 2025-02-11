import Foundation

public extension NSDecimalNumber {
    
    private static let formatter = NumberFormatter()
    
    func toString(locale: Locale,
                  style: NumberFormatter.Style = .decimal,
                  fractionDigits: Int = 2) -> String {
        Self.formatter.locale = locale
        Self.formatter.numberStyle = style
        Self.formatter.maximumFractionDigits = fractionDigits
        Self.formatter.minimumFractionDigits = fractionDigits
        return Self.formatter.string(from: self) ?? ""
    }
    
    static func from(string: String,
                     locale: Locale,
                     style: NumberFormatter.Style = .decimal) -> NSDecimalNumber? {
        guard !string.isEmpty else {
            return NSDecimalNumber.zero
        }
        guard string != (locale.decimalSeparator ?? "") else {
            return NSDecimalNumber.zero
        }
        Self.formatter.locale = locale
        Self.formatter.numberStyle = style
        if let number = Self.formatter.number(from: string) {
            return NSDecimalNumber.init(decimal: number.decimalValue)
        }
        return nil
    }
}
