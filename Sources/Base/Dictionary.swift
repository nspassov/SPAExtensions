import Foundation

public extension Dictionary where Key == String, Value == String {
    
    func formURLEncodedString() -> String {
        var components = URLComponents()
        components.queryItems = self.map {
            URLQueryItem(name: $0, value: $1.formURLEncodedString())
        }
        if let urlString = components.url?.absoluteString {
            // there's a "?" in front so we must remove it
            let start = urlString.index(urlString.startIndex, offsetBy: 1)
            return String(urlString[start...])
        }
        return ""
    }
}
