//
//  Service.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit
import Combine

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown: return "Unknown error"
        case .apiError(let reason): return reason
        }
    }
}

protocol EndPointType {
    var url: URL? { get }
}

protocol ServiceType {
    func get(_ endpoint: EndPointType) -> AnyPublisher<Data, APIError>
}

struct Service: ServiceType {
    func get(_ endpoint: EndPointType) -> AnyPublisher<Data, APIError> {
        
        guard let url = endpoint.url else { fatalError("BAD URL")}

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(tryMap)
            .mapError(mapError)
            .eraseToAnyPublisher()
    }
}

// MARK: - Helpers
private extension Service {
    
    func tryMap(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw APIError.unknown
        }
        return data
    }
    
    func mapError(_ error: Error) -> APIError {
        if let error = error as? APIError {
            return error
        } else {
            return APIError.apiError(reason: error.localizedDescription)
        }
    }
}
