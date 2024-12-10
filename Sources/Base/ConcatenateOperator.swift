import Foundation

infix operator ++ : AdditionPrecedence
infix operator ++= : AdditionPrecedence

// MARK: - String

/// Concatenate by adding a space
public func ++ (a: String, b: String) -> String {
    if !a.isEmpty && !b.isEmpty {
        return a + " " + b
    }
    else {
        return a + b
    }
}

/// Concatenate by adding a space
public func ++ (a: String, b: String?) -> String {
    if let b = b {
        return a ++ b
    }
    return a
}

/// Concatenate by adding a space
public func ++ (a: String?, b: String) -> String {
    if let a = a {
        return a ++ b
    }
    return b
}

/// Concatenate by adding a space
public func ++= (a: inout String, b: String) {
    let res = a ++ b
    a = res
}

/// Concatenate by adding a space
public func ++= (a: inout String?, b: String) {
    let res = a ++ b
    a = res
}

/// Concatenate by adding a space
public func ++= (a: inout String, b: String?) {
    let res = a ++ b
    a = res
}
