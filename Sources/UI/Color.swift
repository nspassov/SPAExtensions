import SwiftUI

public extension Color {
    
    init(from hexInt: Int, opacity: Double = 1) {
        let r = Double((hexInt >> 16) & 0xff) / 255
        let g = Double((hexInt >> 08) & 0xff) / 255
        let b = Double((hexInt >> 00) & 0xff) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
    
    init?(from hexString: String, opacity: Double = 1) {
        let start = hexString.index(hexString.startIndex,
                                    offsetBy: hexString.hasPrefix("#") ? 1 : 0)
        if String(hexString[start...]).count == 6 {
            let hexInt = Int(from: hexString)
            self.init(from: hexInt, opacity: opacity)
            return
        }
        return nil
    }
}
