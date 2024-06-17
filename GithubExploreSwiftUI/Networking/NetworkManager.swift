//
//  NetworkManager.swift
//  GithubRepoAppSwift
//
//  Created by Raj Shekhar on 02/06/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest<Q: Codable>(url: URL, completion: @escaping (Result<Q, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func makeRequest<Q: Codable>(url: URL, completion: @escaping (Result<Q, Error>) -> Void) {
        let urlRequest = URLRequest(url: url)
        Loader.shared.isLoading = true

        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                Loader.shared.isLoading = false
            }

            // Check for general networking errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Ensure there is a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                let unknownError = NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
                completion(.failure(unknownError))
                return
            }

            // Check HTTP status code for errors
            switch httpResponse.statusCode {
            case 200...299:
                // Status code indicates success, continue with decoding
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Q.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    let unknownError = NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(unknownError))
                }
            default:
                // Handle other status codes as errors
                let statusCodeError = NSError(domain: "NetworkManager", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)])
                completion(.failure(statusCodeError))
            }
        }

        task.resume()
    }

}
