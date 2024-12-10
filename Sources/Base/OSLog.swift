import OSLog

public func debugLog(_ objs: CustomStringConvertible...) {
    os_log(.debug, "[%@] %@", Date.now.timestampForRequest(), objs.map { $0.description}.joined(separator: " "))
}

public func errorLog(_ objs: CustomStringConvertible...) {
    os_log(.error, "[%@] %@", Date.now.timestampForRequest(), objs.map { $0.description}.joined(separator: " "))
}
