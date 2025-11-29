import Foundation

infix operator ???: NilCoalescingPrecedence

public func ???<T1, T2>(value: T1?, expression: @escaping(T1) -> T2) -> T2? {
    if let value = value {
        return expression(value)
    } else {
        return nil
    }
}
