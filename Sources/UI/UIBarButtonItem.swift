import UIKit

public extension UIBarButtonItem {
    
    private class ClosureWrapper {
        let closure: (UIBarButtonItem) -> Void
        
        init(_ closure: @escaping (UIBarButtonItem) -> Void) {
            self.closure = closure
        }
        
        @objc func invoke(sender: UIBarButtonItem) {
            closure(sender)
        }
    }
    
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, action: @escaping(UIBarButtonItem) -> Void) {
        let sleeve = ClosureWrapper(action)
        self.init(barButtonSystemItem: systemItem, target: sleeve, action: #selector(ClosureWrapper.invoke(sender:)))
        objc_setAssociatedObject(self,
                                 String(ObjectIdentifier(self).hashValue),
                                 sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    convenience init(title: String, action: @escaping(UIBarButtonItem) -> Void) {
        let sleeve = ClosureWrapper(action)
        self.init(title: title, style: .plain, target: sleeve, action: #selector(ClosureWrapper.invoke(sender:)))
        objc_setAssociatedObject(self,
                                 String(ObjectIdentifier(self).hashValue),
                                 sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    convenience init(image: UIImage?, action: @escaping(UIBarButtonItem) -> Void) {
        let sleeve = ClosureWrapper(action)
        self.init(image: image, style: .plain, target: sleeve, action: #selector(ClosureWrapper.invoke(sender:)))
        objc_setAssociatedObject(self,
                                 String(ObjectIdentifier(self).hashValue),
                                 sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
