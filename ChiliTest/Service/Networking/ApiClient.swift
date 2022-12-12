//
//  ApiClient.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Combine
import Foundation

class APIClient {
    enum HTTPMethod {
        case get(items: [String: Any] = [:])
        case post(body: Data?, items: [String: Any] = [:])
        case put(body: Data?)
        case patch(body: Data?)
        case delete(body: Data? = nil)
        
        var httpString: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }
    
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(APIClient.decoderDateFormatter)
        return decoder
    }()
    
    private static var decoderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // RFC-2822 Format
        formatter.timeZone = .current
        return formatter
    }()
    
    private static var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache.shared
        config.waitsForConnectivity = true
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    
    static func urlRequest(url: URL, method: HTTPMethod) -> URLRequest {
        
        let endpoint = Endpoint(url: url, method: method)
        
        guard let url = endpoint.url else {
            fatalError()
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.httpString
        switch method {
        case .post(let body, _):
            request.httpBody = body
        case .put(let body):
            request.httpBody = body
        case .patch(let body):
            request.httpBody = body
        case .delete(let body):
            request.httpBody = body
        default:
            break
        }
        
        return request
    }
    
    static func createPublisher<T: Codable>(for request: URLRequest) -> AnyPublisher<T, APIError> {
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    guard let error = try? decoder.decode(ErrorResponse.self, from: data) else {
                        let message = "path=\(httpResponse.url?.path ?? "")"
                        let customError = ErrorResponse(success: false, code: httpResponse.statusCode, message: message)
                        throw customError.apiError
                    }
                    throw error.apiError
                }
                
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    let customError = APIError.apiError(code: 9999, reason: String(describing: error))
                    return customError
                }
            }
            .eraseToAnyPublisher()
    }
    
    static func convertFrom<InputObject: Encodable>(object: InputObject) -> [String: Encodable] {
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let json = try encoder.encode(object)
            
            let dictionary = (try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: Any] ?? [:])
                .reduce(into: [String: Encodable]()) { (dict, item) in
                    if item.value is String {
                        dict[item.key] = item.value as? String ?? ""
                    } else if item.value is Int {
                        dict[item.key] = item.value as? Int ?? 0
                    } else if item.value is [String] {
                        dict[item.key] = item.value as? [String] ?? false
                    }
                }
            return  dictionary.mapValues { $0 }
        } catch {
            return [:]
        }
    }
    
    static func addApiKey(to dictionary: inout [String: Encodable]) {
        dictionary["api_key"] = Constants.giphyApiKey
    }
}

extension APIClient {
    fileprivate struct ErrorResponse: Decodable {
        let success: Bool
        let code: Int
        let message: String
        var apiError: APIError {
            .apiError(code: 9999, reason: message)
        }
    }
}

extension APIClient {
    func search(_ model: RequestQuery.SearchGifInterval) -> AnyPublisher<ResponseModels.SearchResponse, APIError> {
        var params = APIClient.convertFrom(object: model)
        APIClient.addApiKey(to: &params)
        let request = APIClient.urlRequest(url: URL.search, method: .get())
        return APIClient.createPublisher(for: request)
    }
}
