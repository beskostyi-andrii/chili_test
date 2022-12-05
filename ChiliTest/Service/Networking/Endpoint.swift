//
//  Endpoint.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation

public typealias QueryKey = String
public typealias QueryValue = Encodable

public struct Endpoint {
    
    public var scheme = "https"
    public var host = ""
    public let path: String
    public var queryItems: [URLQueryItem]?
    
    public var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    init(path: String, queryItems: [QueryKey: QueryValue]? = nil, host: String? = nil, scheme: String? = nil) {
        self.path = path
        
        if let queryItems = queryItems {
            var queries = [URLQueryItem]()
            queryItems.forEach { queries.append(URLQueryItem(name: $0.key, value: "\($0.value)")) }
            self.queryItems = queries
        }
        
        if let host = host { self.host = host }
        if let scheme = scheme { self.scheme = scheme }
    }
    
    init(url: URL, method: APIClient.HTTPMethod) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Error: creating URLComponents")
        }
        
        self.path = components.path
        
        switch method {
        case .get(let params):
            if !params.isEmpty {
                self.queryItems = params.map {
                    URLQueryItem(name: $0.key, value: String(describing: $0.value))
                }
            }
        case .post(_, let params):
            if !params.isEmpty {
                self.queryItems = params.map {
                    URLQueryItem(name: $0.key, value: String(describing: $0.value))
                }
            }
        default:
            break
        }
        
        if let host = components.host { self.host = host }
        if let scheme = components.scheme { self.scheme = scheme }
    }
}
