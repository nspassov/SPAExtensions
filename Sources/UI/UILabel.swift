import UIKit

public extension UILabel {
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    convenience init(_ attributedText: NSAttributedString?) {
        self.init(frame: .zero)
        self.attributedText = attributedText
    }
}
