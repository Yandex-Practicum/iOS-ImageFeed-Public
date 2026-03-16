//
//  URLSession.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 19.11.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= responseCode {
                } else {
                    completion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        })
        return task
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
}

