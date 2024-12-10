import Foundation

public extension NSAttributedString {
    
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    static func += (left: inout NSAttributedString, right: NSAttributedString) {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        left = result
    }
    
    static func space() -> NSAttributedString {
        return NSAttributedString(string: " ")
    }
    
    static func thinSpace() -> NSAttributedString {
        return NSAttributedString(string: "\u{2009}")
    }
    
    static func newLine() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
}

/// Concatenate by adding a space
public func ++ (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    if !left.string.isEmpty && !right.string.isEmpty {
        return left + NSAttributedString.space() + right
    }
    else {
        return left + right
    }
}

/// Concatenate by adding a space
public func ++ (left: NSAttributedString, right: NSAttributedString?) -> NSAttributedString {
    if let right = right {
        return left ++ right
    }
    return left
}

/// Concatenate by adding a space
public func ++ (left: NSAttributedString?, right: NSAttributedString) -> NSAttributedString {
    if let left = left {
        return left ++ right
    }
    return right
}

/// Concatenate by adding a space
public func ++= (a: inout NSAttributedString, b: NSAttributedString) {
    let res = a ++ b
    a = res
}

/// Concatenate by adding a space
public func ++= (a: inout NSAttributedString?, b: NSAttributedString) {
    let res = a ++ b
    a = res
}

/// Concatenate by adding a space
public func ++= (a: inout NSAttributedString, b: NSAttributedString?) {
    let res = a ++ b
    a = res
}
