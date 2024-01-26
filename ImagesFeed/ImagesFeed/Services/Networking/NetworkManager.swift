//
//  NetworkManager.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 18.12.2023.
//  
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    private var task: URLSessionTask?
    
    private init() {
        self.session = URLSession(configuration: .default)
    }
    
    func request<T: Codable>(
        endpoint: EndpointManager,
        method: HTTPMethod,
        body: Body? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, Error>
        ) -> Void) -> URLSessionTask? {
        performRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            headers: headers,
            completion: completion
        )
    }
    
    private func performRequest<T: Codable>(
        endpoint: EndpointManager,
        method: HTTPMethod,
        body: Body?,
        headers: [String: String]?,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask? {
        var request = Self.buildRequest(endpoint: endpoint, method: method, body: body)
        
        if let headers = headers {
            headers.forEach { key, value in
                request?.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        guard let finalRequest = request else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return nil
        }
        
        let task = session.dataTask(with: finalRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        return task
    }
}

private extension NetworkManager {
    
    private static func buildRequest(endpoint: EndpointManager, method: HTTPMethod, body: Body? = nil) -> URLRequest? {
        guard let url = URL(string: endpoint.urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body {
            switch body {
            case let .dict(bodyDict):
                request.httpBody = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
            case let .data(bodyData):
                request.httpBody = bodyData
            case let .encodable(bodyObject):
                request.httpBody = try? JSONEncoder().encode(bodyObject)
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

extension NetworkManager {
    
    enum Body {
        case dict([String: Any])
        case data(Data)
        case encodable(Encodable)
    }
}
