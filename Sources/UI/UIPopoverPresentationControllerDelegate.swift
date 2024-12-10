import UIKit

public protocol PopoverPresentationSourceView {
}

extension UIBarButtonItem: PopoverPresentationSourceView {
}

extension UIView: PopoverPresentationSourceView {
}

public extension UIPopoverPresentationControllerDelegate where Self: UIViewController {
    
    func present(popover: UIViewController,
                 from sourceView: PopoverPresentationSourceView,
                 size: CGSize,
                 arrowDirection: UIPopoverArrowDirection) {

        popover.modalPresentationStyle = .popover
        popover.preferredContentSize = size
        let popoverController = popover.popoverPresentationController
        popoverController?.delegate = self
        if let aView = sourceView as? UIView {
            popoverController?.sourceView = aView
            popoverController?.sourceRect = CGRect(x: aView.bounds.midX, y: aView.bounds.midY, width: 0, height: 0)
        } else if let barButtonItem = sourceView as? UIBarButtonItem {
            popoverController?.barButtonItem = barButtonItem
        }
        popoverController?.permittedArrowDirections = arrowDirection
        present(popover, animated: true, completion: nil)
    }
    
    func present(_ viewController: UIViewController, from sender: PopoverPresentationSourceView) {
        viewController.view.sizeToFit()
        viewController.view.invalidateIntrinsicContentSize()
        let size = CGSize(width: self.view.bounds.width, height: 0)
        DispatchQueue.main.async {
            let s = viewController.view.systemLayoutSizeFitting(size,
                                                                withHorizontalFittingPriority: .required,
                                                                verticalFittingPriority: .defaultLow)
            self.present(popover: viewController, from: sender, size: s, arrowDirection: .up)
        }
    }
}
