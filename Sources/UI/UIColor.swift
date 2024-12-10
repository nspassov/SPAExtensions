import UIKit

extension UIColor {
    
    convenience init(_ rgb: Int, alpha: CGFloat = 1) {
        let r = CGFloat((rgb >> 16) & 0xff) / 255
        let g = CGFloat((rgb >> 08) & 0xff) / 255
        let b = CGFloat((rgb >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

