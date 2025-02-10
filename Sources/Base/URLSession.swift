import Foundation

public extension URLSession {
    
    @MainActor
    func perform<ResultType>(_ request: URLRequest,
                             checkResponse: ((HTTPURLResponse) -> ())? = nil,
                             parseResponse: @escaping(Data) throws -> (ResultType),
                             parseErrorResponse: @escaping(Data) throws -> CommonError = { _ in throw CommonError.custom("No error parsing") }) async ->
        Result<ResultType, CommonError> {
        
        do {
            let rawResponse = try await self.data(for: request)
            
            if let response = rawResponse.1 as? HTTPURLResponse {
                checkResponse?(response)
                
                if response.httpStatus == .success {
                    do {
                        let data = try parseResponse(rawResponse.0)
                        return .success(data)
                    }
                    catch let e as CommonError {
                        request.httpDebugLog(e.description)
                        return .failure(.api("Could not parse API response"))
                    }
                }
                else if response.statusCode == 401 {
                    return .failure(try parseErrorResponse(rawResponse.0) ?!? .session(.missingToken))
                }
                else if response.statusCode == 403 {
                    return .failure(try parseErrorResponse(rawResponse.0) ?!? .api("No authorization for this resource"))
                }
                else if response.statusCode == 404 {
                    return .failure(try parseErrorResponse(rawResponse.0) ?!? .api("Resource not found"))
                }
                else if response.httpStatus == .clientError {
                    request.httpDebugLog("Error \(response.statusCode)")
                    return .failure(try parseErrorResponse(rawResponse.0) ?!? .client(.invalidInput))
                }
                request.httpDebugLog(String(format: "Returned HTTP status code %@", String(describing: response.statusCode)))
            }
            return .failure(.server(.internal))
        }
        catch let e {
            request.httpDebugLog(e.localizedDescription)
            return  .failure(e.kind ?? .custom(e.localizedDescription))
        }
    }
}


public extension URLRequest {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    fileprivate func httpDebugLog(_ s: String) {
#if DEBUG
        debugLog(String(format: "[%@%@] %@", self.url?.host ?? "", self.url?.path() ?? "", s))
#endif
    }
}


public extension HTTPURLResponse {
    enum Status {
        case success
        case clientError
        case serverError
        case unsupported
    }
    
    var httpStatus: Status {
        switch self.statusCode / 100 {
        case 2: return .success
        case 4: return .clientError
        case 5: return .serverError
        default: return .unsupported
        }
    }
}
