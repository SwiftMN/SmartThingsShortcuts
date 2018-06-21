//
//  SmartThingsAPI.swift
//  SmartThingsShortcuts
//
//  Created by Steven Vlaminck on 6/8/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import Foundation

protocol SmartThingsApi {
    func listScenes(completion: @escaping (Response<[Scene]>) -> Void)
    func executeScene(id: String, completion: @escaping (Response<[String: String]?>) -> Void)
}

class SmartThings: SmartThingsApi {
    
    static let API = SmartThings()
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func listScenes(completion: @escaping (Response<[Scene]>) -> Void) {
        fetchAllPages(request: Endpoint.listScenes.request, items: [Scene](), completion: completion)
    }
    
    func executeScene(id: String, completion: @escaping (Response<[String: String]?>) -> Void) {
        make(request: Endpoint.executeScene(id: id).request, completion: completion)
    }
}

/// implementation details
private extension SmartThings {
    func make<U: Decodable>(request: URLRequest?, completion: @escaping (Response<U>) -> Void) {
        guard let request = request else {
            completion(.error(RequestError.invalidUrl))
            return
        }
        🐛("making request: \(request)")
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let body = try JSONDecoder().decode(U.self, from: data)
                    completion(.success(body))
                } catch {
                    completion(.error(error))
                }
            } else {
                completion(.error(error ?? RequestError.unknown))
            }
        }
        task.resume()
    }
    
    func fetchAllPages<U: Decodable>(request: URLRequest?, items: [U], completion: @escaping (Response<[U]>) -> Void) {
        guard let request = request else {
            completion(.error(RequestError.invalidUrl))
            return
        }
        make(request: request) { [weak self] (response: Response<PagedResult<U>>) in
            switch response {
            case .success(let result):
                let aggregatedItems: [U] = items + result.items
                if let nextRequest = result.nextRequest {
                    self?.fetchAllPages(request: nextRequest, items: aggregatedItems, completion: completion)
                } else {
                    completion(.success(aggregatedItems))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
