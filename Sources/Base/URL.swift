import UIKit

public extension URL {
    
    @MainActor @discardableResult func openExternally() async -> Bool {
        if UIApplication.shared.canOpenURL(self) {
            return await UIApplication.shared.open(self, options: [:])
        }
        else {
            return false
        }
    }
}
