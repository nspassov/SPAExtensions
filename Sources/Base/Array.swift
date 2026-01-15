import Foundation

public extension Array {
    
    mutating func appendAll(_ elements: [Element]) {
        for element in elements {
            self.append(element)
        }
    }
}
