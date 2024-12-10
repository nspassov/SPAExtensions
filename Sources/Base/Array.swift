import Foundation

public extension Array {
    
    mutating func appendAll(_ elements: [Element]) {
        for element in elements {
            self.append(element)
        }
    }
}

public extension Set {
    
    mutating func insertAll(_ elements: Set<Element>) {
        for element in elements {
            self.insert(element)
        }
    }
    
    mutating func insertAll(_ elements: [Element]) {
        for element in elements {
            self.insert(element)
        }
    }
    
    mutating func filtered(_ isIncluded: (Element) -> Bool) {
        self.forEach { element in
            if !isIncluded(element) {
                self.remove(element)
            }
        }
    }
}
