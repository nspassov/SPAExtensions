import Foundation

public extension Result where Success == Void {
    
    static var success: Result {
        .success(())
    }
}

public extension Result {
    
    var failure: Error? {
        if case .failure(let error) = self {
           return error
        }
        else {
            return nil
        }
    }
}

public extension Result where Failure == CommonError {
    
    var failure: CommonError? {
        if case .failure(let error) = self {
           return error
        }
        else {
            return nil
        }
    }
}
