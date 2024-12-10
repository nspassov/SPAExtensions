import UIKit
import Combine

public extension UIButton {
    
    convenience init(frame: CGRect = .zero, title: String) {
        self.init(frame: frame)
        setTitle(title, for: .normal)
    }
    
    convenience init(title: NSAttributedString?, action: @escaping () -> Void) {
        self.init(frame: .zero)
        setAttributedTitle(title, for: .normal)
        addAction(action)
    }
    
    convenience init(title: String,
                     tintColor: UIColor = .systemBlue,
                     configuration: UIButton.Configuration? = nil,
                     action: @escaping () -> Void) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        self.tintColor = tintColor
        self.configuration = configuration
        addAction(action)
    }
    
    convenience init(title: NSAttributedString?,
                     tintColor: UIColor = .systemBlue,
                     configuration: UIButton.Configuration? = nil,
                     action: @escaping () -> Void) {
        self.init(frame: .zero)
        setAttributedTitle(title, for: .normal)
        self.tintColor = tintColor
        self.configuration = configuration
        addAction(action)
    }
    
    
    func addAction(for event: UIControl.Event = .touchUpInside,
                   title: String,
                   _ action: @escaping () -> Void) {
        self.setTitle(title, for: UIButton.State.normal)
        self.addAction(for: event, action)
    }
    
    func title() -> NSAttributedString {
        if let title = attributedTitle(for: .normal) {
            return title
        }
        else {
            return NSAttributedString(string: title(for: .normal) ?? "")
        }
    }

    func setMultilineTitle(insets: UIEdgeInsets = .zero) {
        if titleLabel == nil {
            setTitle(" ", for: .normal)
        }
        guard let titleLabel else {
            return
        }
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }

    func setMultilineTitle(title: NSAttributedString?, insets: UIEdgeInsets = .zero) {
        setAttributedTitle(title, for: .normal)
        setMultilineTitle(insets: insets)
    }
}

public extension UIButton {
    var publisher: Publishers.ButtonPublisher {
        return Publishers.ButtonPublisher(button: self)
    }
}

public extension Publishers {
    struct ButtonPublisher: @preconcurrency Publisher {
        public typealias Output = Void
        public typealias Failure = Never
        
        private let button: UIButton
        
        init(button: UIButton) { self.button = button }
        
        @MainActor
        public func receive<S>(subscriber: S) where S : Subscriber, Publishers.ButtonPublisher.Failure == S.Failure, Publishers.ButtonPublisher.Output == S.Input {
            let subscription = ButtonSubscription(subscriber: subscriber, button: button)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class ButtonSubscription<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
        
        private var subscriber: S?
        private weak var button: UIButton?
        
        @MainActor
        init(subscriber: S, button: UIButton) {
            self.subscriber = subscriber
            self.button = button
            subscribe()
        }
        
        public func request(_ demand: Subscribers.Demand) { }
        
        public func cancel() {
            subscriber = nil
            button = nil
        }
        
        @MainActor
        private func subscribe() {
            button?.addTarget(self,
                              action: #selector(tap(_:)),
                              for: .touchUpInside)
        }
        
        @MainActor
        @objc private func tap(_ sender: UIButton) {
            _ = subscriber?.receive(())
        }
    }
}
