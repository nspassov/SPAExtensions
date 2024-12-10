import UIKit

public extension UIControl {
    
    private class ClosureWrapper {
        let closure: () -> Void
        
        init(_ closure: @escaping () -> Void) {
            self.closure = closure
        }
        
        @objc func invoke() {
            closure()
        }
    }
    
    func addAction(for event: UIControl.Event = .touchUpInside,
                   _ action: (() -> Void)?) {
        
        if let action = action {
            let action = UIAction(identifier: UIAction.Identifier(String(event.rawValue)), handler: { _ in action() })
            addAction(action, for: event)
        }
        else {
            removeAction(identifiedBy: UIAction.Identifier(String(event.rawValue)), for: event)
        }
    }
    
    func removeAction(for event: UIControl.Event = .touchUpInside) {
        removeAction(identifiedBy: UIAction.Identifier(String(event.rawValue)), for: event)
    }
}


public extension UIGestureRecognizer {
    
    private class ClosureWrapper {
        let closure: (UIGestureRecognizer) -> Void
        
        init(_ closure: @escaping (UIGestureRecognizer) -> Void) {
            self.closure = closure
        }
        
        @objc func invoke(sender: UIGestureRecognizer) {
            closure(sender)
        }
    }
    
    convenience init(action: @escaping(UIGestureRecognizer) -> Void) {
        let sleeve = ClosureWrapper(action)
        self.init(target: sleeve, action: #selector(ClosureWrapper.invoke(sender:)))
        objc_setAssociatedObject(self,
                                 String(ObjectIdentifier(self).hashValue),
                                 sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
