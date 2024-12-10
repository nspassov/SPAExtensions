import UIKit

public extension UIView {
    
    func resignAnyFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Sometimes `UIViewController.view.safeAreaInsets` is `.zero` but you still need access to these values
    static var safeAreaInsetsOfMainWindow: UIEdgeInsets {
        return (UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate)?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    func addSubview(_ view: UIView, activateConstraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(activateConstraints)
    }
    
    func addSubviews(_ views: [UIView], activateConstraints: [NSLayoutConstraint]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate(activateConstraints)
    }
    
    func addSubview(_ view: UIView, layout: @escaping(UIView, UIView) -> ([NSLayoutConstraint])) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(layout(self, view))
    }
    
    func addEnclosedSubview(_ view: UIView,
                            insets: NSDirectionalEdgeInsets = .zero,
                            toSafeArea: Bool = false) {
        if toSafeArea {
            addSubview(view, activateConstraints: [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
                view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: insets.leading),
                view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -insets.trailing),
            ])
        }
        else {
            addSubview(view, activateConstraints: [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insets.bottom),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.leading),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.trailing),
            ])
        }
    }
    
    func addCenteredSubview(_ view: UIView, offset: CGSize = .zero) {
        addSubview(view, activateConstraints: [
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: offset.width),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: offset.height),
        ])
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

public extension UIStackView {
    
    func addArrangedLabel(_ label: UILabel) {
        if label.attributedText?.string.isEmpty ?? true && label.text?.isEmpty ?? true {
            return
        }
        self.addArrangedSubview(label)
    }
}
