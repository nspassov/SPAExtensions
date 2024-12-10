import UIKit

public extension UIImage {
    
    static func system(name: String,
                       configuration: SymbolConfiguration? = nil,
                       tintColor: UIColor = .systemBlue,
                       renderingMode: UIImage.RenderingMode = .automatic) -> UIImage? {
        
        return UIImage(systemName: name, withConfiguration: configuration)?
            .withTintColor(tintColor, renderingMode: renderingMode)
    }
}

public extension String {
    
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        let finalSize = CGSize(width: 30.0, height: 30.0)
        let keys: [NSAttributedString.Key] = [.font, .foregroundColor]
        return UIGraphicsImageRenderer(size: finalSize).image { ctx in
            
            if let bgc = attributes?[NSAttributedString.Key.backgroundColor] as? UIColor {
                
                ctx.cgContext.addEllipse(in: CGRect(origin: .zero, size: finalSize))
                ctx.cgContext.setFillColor(bgc.cgColor)
                ctx.cgContext.fillPath()
            }
            let filteredAttributes = attributes?.filter({ itm in keys.contains(itm.key) })
            let transform = CGAffineTransform(translationX: (finalSize.width-size.width) / 2, y: (finalSize.height-size.height) / 2)
            let rect = CGRect(origin: .zero, size: size).applying(transform)
            (self as NSString).draw(in: rect, withAttributes: filteredAttributes)
        }
    }
    
    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 1024) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context

        return image ?? UIImage()
    }
}
