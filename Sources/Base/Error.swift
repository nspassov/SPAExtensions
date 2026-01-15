import Foundation

public enum CommonError: Error, CustomStringConvertible {
    case network(_ reason: Network)
    case session(_ reason: Session)
    case server(_ reason: Server)
    case client(_ reason: Client)
    case api(_ message: String)
    case custom(_ message: String)
    
    public enum Network: String, Error {
        case down = "No Internet connection. Please check your network settings and try again"
        case timeout = "Your Internet connection is unstable. Please check your network settings and try again"
        case tlsError = "A secure connection could not be established. Please check your network settings and try again"
    }
    
    public enum Session: String, Error {
        case missingToken = "Authentication with the server failed. Please check your login credentials and try to log in again"
        case missingCredentials = "Missing credentials, please re-login"
        case disconnected = "Failed connecting to the server"
    }
    
    public enum Server: String, Error {
        case `internal` = "Internal server error"
        case apiResponse = "Unsupported/Malformed API response"
        case down = "Service unavailable"
    }
    
    public enum Client: String, Error {
        case invalidInput = "Incorrect input parameters"
        case missingParameters = "Required parameters are missing"
        case requiredFields = "Please fill in the mandatory fields"
        case requiredFieldInteger = "Please enter a valid integer"
    }
    
    public var title: String {
        switch self {
        case .network(_):
            return "Network Error"
        case .session(_):
            return "Session Error"
        case .server(_):
            return "Server Error"
        case .client(_):
            return "Input Error"
        case .api(_):
            return "Protocol Error"
        case .custom(_):
            return "Error"
        }
    }
    
    public var reason: String {
        switch self {
        case .network(let reason):
            return reason.rawValue
        case .session(let reason):
            return reason.rawValue
        case .server(let reason):
            return reason.rawValue
        case .client(let reason):
            return reason.rawValue
        case .api(let message), .custom(let message):
            return message
        }
    }
    
    public var description: String {
        return "\(title): \(reason)"
    }
}


public extension Error {
    var kind: CommonError? {
        if errorDomain == "NSURLErrorDomain" {
            switch code {
            case -1001:
                return .network(.timeout)
            case -1200:
                return .network(.tlsError)
            case -1202:
                return .network(.tlsError)
            case -1005:
                return .network(.down)
            case -1011:
                return .server(.down)
            default:
                return .custom(self.localizedDescription)
            }
        }
        else if errorDomain == "NSPOSIXErrorDomain" {
            switch code {
            case 57, 54:
                return .session(.disconnected)
            default:
                return .custom(self.localizedDescription)
            }
        }
        return nil
    }
    
    var code: Int {
        return (self as NSError).code
    }
    
    var errorDomain: String {
        return (self as NSError).domain
    }
    
    var errorURL: String {
        return (self as NSError).userInfo["NSErrorFailingURLStringKey"] as? String ?? ""
    }
}
