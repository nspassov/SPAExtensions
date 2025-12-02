import UIKit

public extension UIColor {
    
    convenience init(from hexInt: Int, alpha: CGFloat = 1) {
        let r = CGFloat((hexInt >> 16) & 0xff) / 255
        let g = CGFloat((hexInt >> 08) & 0xff) / 255
        let b = CGFloat((hexInt >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init?(from hexString: String, alpha: CGFloat = 1) {
        let start = hexString.index(hexString.startIndex,
                                    offsetBy: hexString.hasPrefix("#") ? 1 : 0)
        if String(hexString[start...]).count == 6 {
            let hexInt = Int(from: hexString)
            self.init(from: hexInt, alpha: alpha)
            return
        }
        return nil
    }
}
