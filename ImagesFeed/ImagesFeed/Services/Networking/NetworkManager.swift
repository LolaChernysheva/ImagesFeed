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
    
    private init() {
        self.session = URLSession(configuration: .default)
    }
    
    func request<T: Codable>(endpoint: EndpointManager, method: HTTPMethod, body: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(endpoint: endpoint, method: method, body: body, completion: completion)
    }
    
    func request<T: Codable>(endpoint: EndpointManager, method: HTTPMethod, body: Codable? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(endpoint: endpoint, method: method, body: body, completion: completion)
    }
    
    func request<T: Codable>(endpoint: EndpointManager, method: HTTPMethod, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(endpoint: endpoint, method: method, body: body, completion: completion)
    }
    
    private func performRequest<T: Codable>(endpoint: EndpointManager, method: HTTPMethod, body: Any?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = Self.buildRequest(endpoint: endpoint, method: method, body: body) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
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
    }
}

private extension NetworkManager {
    
    static func buildRequest(endpoint: EndpointManager, method: HTTPMethod, body: Any? = nil) -> URLRequest? {
        guard let url = URL(string: endpoint.urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let bodyData = body as? Data {
            request.httpBody = bodyData
        } else if let bodyObject = body as? Encodable {
            request.httpBody = try? JSONEncoder().encode(bodyObject)
        } else if let bodyDict = body as? [String: Any] {
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

extension NetworkManager {
    
}
