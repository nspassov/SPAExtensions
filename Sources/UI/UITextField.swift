import UIKit
import Combine

public extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
            return NotificationCenter.default
            .publisher( for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
        }
  }


public extension UITextField {
    var publisher: Publishers.TextFieldPublisher {
        return Publishers.TextFieldPublisher(textField: self)
    }
}

public extension Publishers {
    struct TextFieldPublisher: @preconcurrency Publisher {
        public typealias Output = String
        public typealias Failure = Never
        
        private let textField: UITextField
        
        init(textField: UITextField) { self.textField = textField }
        
        @MainActor
        public func receive<S>(subscriber: S) where S : Subscriber, Publishers.TextFieldPublisher.Failure == S.Failure, Publishers.TextFieldPublisher.Output == S.Input {
            let subscription = TextFieldSubscription(subscriber: subscriber, textField: textField)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class TextFieldSubscription<S: Subscriber>: Subscription where S.Input == String, S.Failure == Never  {
        
        private var subscriber: S?
        private weak var textField: UITextField?
        
        @MainActor
        init(subscriber: S, textField: UITextField) {
            self.subscriber = subscriber
            self.textField = textField
            subscribe()
        }
        
        public func request(_ demand: Subscribers.Demand) { }
        
        public func cancel() {
            subscriber = nil
            textField = nil
        }
        
        @MainActor
        private func subscribe() {
            textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        @MainActor
        @objc private func textFieldDidChange(_ textField: UITextField) {
            _ = subscriber?.receive(textField.text ?? "")
        }
    }
}
