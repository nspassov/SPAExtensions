import Foundation

infix operator ?!?: NilCoalescingPrecedence

public func ?!?<T>(expression: @autoclosure() throws -> T, fallbackValue: T) -> T {
    do {
        return try expression()
    } catch {
        return fallbackValue
    }
}
