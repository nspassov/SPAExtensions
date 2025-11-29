import Foundation

infix operator ?!: NilCoalescingPrecedence

public func ?!<T>(value: T?, error: @autoclosure() -> Error) throws -> T {
    if let value = value { return value }
    throw error()
}
