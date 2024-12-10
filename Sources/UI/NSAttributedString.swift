import UIKit

public extension NSAttributedString {

    convenience init(image: UIImage?, verticalOffset: CGFloat) {
        guard let image = image else {
            self.init(string: "")
            return
        }
        let imageAttachment = ImageAttachment(image, verticalOffset: verticalOffset)
        let imageString = NSAttributedString(attachment: imageAttachment)
        self.init(attributedString: imageString)
    }
    
    convenience init(string: String,
                     uppercased: Bool = false,
                     color: UIColor? = nil,
                     backgroundColor: UIColor? = nil,
                     font: UIFont? = nil,
                     shadowColor: UIColor? = nil,
                     lineSpacing: CGFloat = 1,
                     paragraphSpacing: CGFloat = 0,
                     alignment: NSTextAlignment = .left,
                     lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        
        let str = uppercased ? string.uppercased() : string
        let attributes = Self.createAttributes(color: color,
                                               backgroundColor: backgroundColor,
                                               font: font,
                                               shadowColor: shadowColor,
                                               lineSpacing: lineSpacing,
                                               paragraphSpacing: paragraphSpacing,
                                               alignment: alignment,
                                               lineBreakMode: lineBreakMode)
        self.init(string: str, attributes: attributes)
    }
    
    func restyle(color: UIColor? = nil,
                 lineSpacing: CGFloat = 1,
                 paragraphSpacing: CGFloat = 0,
                 alignment: NSTextAlignment = .left) -> NSAttributedString {
        
        let attributes = Self.createAttributes(color: color,
                                               lineSpacing: lineSpacing,
                                               paragraphSpacing: paragraphSpacing,
                                               alignment: alignment)
        let result = NSMutableAttributedString(attributedString: self)
        result.addAttributes(attributes, range: NSRange(location: 0, length: string.count))
        return result
    }
    
    private static func createAttributes(color: UIColor? = nil,
                                         backgroundColor: UIColor? = nil,
                                         font: UIFont? = nil,
                                         shadowColor: UIColor? = nil,
                                         lineSpacing: CGFloat = 1,
                                         paragraphSpacing: CGFloat = 0,
                                         alignment: NSTextAlignment = .left,
                                         lineBreakMode: NSLineBreakMode = .byWordWrapping) -> [NSAttributedString.Key: Any] {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.lineBreakMode = lineBreakMode

        var attributes: [NSAttributedString.Key: Any] = [:]
        if let color = color {
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        if let backgroundColor = backgroundColor {
            attributes[NSAttributedString.Key.backgroundColor] = backgroundColor
        }
        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }
        if let shadowColor = shadowColor {
            let shadow = NSShadow()
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            shadow.shadowBlurRadius = 3
            attributes[NSAttributedString.Key.shadow] = shadow
        }
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        return attributes
    }
    
    convenience init(format: NSAttributedString, args: NSAttributedString...) {
        let mutableNSAttributedString = NSMutableAttributedString(attributedString: format)

        args.forEach { (attributedString) in
            let range = NSString(string: mutableNSAttributedString.string).range(of: "%@")
            mutableNSAttributedString.replaceCharacters(in: range, with: attributedString)
        }
        self.init(attributedString: mutableNSAttributedString)
    }
    
    func highlight(range: NSRange, color: UIColor) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(self)
        if range.location != NSNotFound {
            var attrs: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.foregroundColor: color]
            if let font = self.attribute(NSAttributedString.Key.font, at: range.location, effectiveRange: nil) as? UIFont {
                attrs[NSAttributedString.Key.font] = font
            }
            result.setAttributes(attrs, range: range)
        }
        return result
    }
    
    func trimmed() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.utf16.description.rangeOfCharacter(from: invertedSet)
        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }

        let location = string.utf16.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.utf16.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
}

// https://gist.github.com/phatmann/582bed5aa0f06432873b
public class ImageAttachment: NSTextAttachment {

    public var accessibilityDescription: String?
    public var verticalOffset: CGFloat = 0
    
    public convenience init(_ image: UIImage,
                            accessibilityDescription: String? = nil,
                            verticalOffset: CGFloat = 0) {
        self.init()
        self.image = image
        self.accessibilityDescription = accessibilityDescription
        self.verticalOffset = verticalOffset
    }

    public override func attachmentBounds(for textContainer: NSTextContainer?,
                                          proposedLineFragment lineFrag: CGRect,
                                          glyphPosition position: CGPoint,
                                          characterIndex charIndex: Int) -> CGRect {
        let height = lineFrag.size.height
        var scale: CGFloat = 1.0
        let imageSize = image?.size ?? .zero
        
        if height < imageSize.height {
            scale = height / imageSize.height
        }
        
        return CGRect(x: 0, y: verticalOffset, width: imageSize.width * scale, height: imageSize.height * scale)
    }
}

public extension NSAttributedString {

    func getImageAttachments() -> [ImageAttachment] {
        let range = NSRange(0..<length)
        guard containsAttachments(in: range) else {
            return []
        }

        var attachments = [ImageAttachment]()
        enumerateAttribute(.attachment, in: NSRange(0..<length)) { attribute, _, _ in
            if let attachment = attribute as? ImageAttachment {
                attachments.append(attachment)
            }
        }

        return attachments
    }

    func getAccessibilityDescription(attachmentsSeparator separator: String = ", ") -> String {
        let attachments = getImageAttachments().compactMap { $0.accessibilityDescription }.joined(separator: separator)
        return attachments.isEmpty ? string : string.appending(separator + attachments)
    }
}

public extension NSAttributedString {

    func height(
        for width: CGFloat = .greatestFiniteMagnitude,
        maximumNumberOfLines: Int = .zero,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> CGFloat {
        guard !string.isEmpty else {
            return .zero
        }

        checkExistingFonts()
        let textStorage = NSTextStorage(attributedString: self)

        let size = CGSize(width: width, height: .greatestFiniteMagnitude)

        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = .zero
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        textContainer.lineBreakMode = lineBreakMode

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)
        layoutManager.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: textContainer)

        let rect = layoutManager.usedRect(for: textContainer)

        return rect.integral.size.height
    }
    
    func width(
        for height: CGFloat = .greatestFiniteMagnitude,
        maximumNumberOfLines: Int = .zero,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> CGFloat {
        guard !string.trimmingCharacters(in: .newlines).isEmpty else {
            return .zero
        }

        checkExistingFonts()
        let textStorage = NSTextStorage(attributedString: self)

        let size = CGSize(width: .greatestFiniteMagnitude, height: height)

        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = .zero
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        textContainer.lineBreakMode = lineBreakMode

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)
        layoutManager.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: textContainer)

        let rect = layoutManager.usedRect(for: textContainer)

        return rect.integral.size.width
    }

    func size() -> CGSize {
        guard !string.isEmpty else {
            return .zero
        }

        checkExistingFonts()
        let textStorage = NSTextStorage(attributedString: self)

        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

        let textContainer = NSTextContainer(size: size)

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)
        layoutManager.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: textContainer)

        let rect = layoutManager.usedRect(for: textContainer)

        return rect.integral.size
    }

    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/TextLayout/Tasks/CountLines.html
    func linesCount(
        height: CGFloat = .greatestFiniteMagnitude,
        width: CGFloat = .greatestFiniteMagnitude,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> Int {
        guard !string.isEmpty else {
            return .zero
        }

        checkExistingFonts()
        let textStorage = NSTextStorage(attributedString: self)

        let size = CGSize(width: width, height: height)

        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = .zero
        textContainer.maximumNumberOfLines = .zero
        textContainer.lineBreakMode = lineBreakMode

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)

        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0, index = 0, lineRange = NSRange(location: 0, length: 1)

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    func truncated(_ lineBreakMode: NSLineBreakMode) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        string.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: string.length))
        return string
    }

    private func checkExistingFonts() {
        var containsFont = false
        enumerateAttribute(.font, in: NSRange(0..<length)) { value, _, _ in
            guard value is UIFont else { return }
            containsFont = true
        }

        #if DEVELOPMENT
        assert(containsFont, "NSAttributedString (\"\(string)\") provided for size calculation does not contain a font")
        #endif
    }

    // MARK: - Replace with Links

    static func multipleAttributedString(generalText: NSAttributedString,
                                         attributedText: NSAttributedString) -> NSAttributedString {
        return generalText.replaceWithLinks([attributedText])
    }

    /// Replaces normal attributed string parts with link parts
    /// - Parameter links: links to be replaced
    private func replaceWithLinks(_ links: [NSAttributedString]) -> NSAttributedString {
        guard let mutableString = self.mutableCopy() as? NSMutableAttributedString else { return self }
        links.forEach { link in
            guard self.string.contains(link.string as String) else { return }
            mutableString.replaceCharacters(in: mutableString.mutableString.range(of: link.string), with: link)
        }
        return mutableString
    }
    
}


public extension NSAttributedString {
    
    static func stringWith(title: String, content: String?, skipEmpty: Bool = false) -> NSAttributedString? {
        guard let content = content else { return nil }
        if content.isEmpty && skipEmpty { return nil }
        let title = NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        let val = NSAttributedString(string:content, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        
        let attr = NSMutableAttributedString()
        attr.append(title)
        attr.append(NSAttributedString(" "))
        attr.append(val)
        return attr
    }
}


public extension Sequence where Element == NSAttributedString {
    
    func joined(separator: String = " ") -> NSAttributedString {
        var result = NSAttributedString(string: "")
        self.forEach({ result = result + NSAttributedString(string: separator) + $0 })
        return result
    }
}
