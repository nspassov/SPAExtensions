import SwiftUI
import UIKit

public extension View {
    func toUIImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }

}

public extension UIImage {
    
    @MainActor
    static func system(name: String, color: UIColor, size: CGFloat) -> UIImage? {
        return Image(systemName: name)
            .foregroundStyle(Color(color))
            .font(.system(size: size))
            .toUIImage()
    }
}
