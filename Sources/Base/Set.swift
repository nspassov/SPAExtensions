import Foundation

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
    
    @discardableResult mutating func toggle(_ element: Element) -> Bool {
        if self.contains(element) {
            self.remove(element)
            return false
        }
        else {
            self.insert(element)
            return true
        }
    }
}
