//
//  Endpoint.swift
//  SmartThingsShortcuts
//
//  Created by Steven Vlaminck on 6/8/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import Foundation

enum Endpoint {
    case listScenes
    case executeScene(id: String)
    
    var request: URLRequest? {
        guard let url = url else {
            💥("Could not make request from endpoint: \(self)")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = method
        return request
    }

    private var value: String {
        switch self {
        case .listScenes: return "/scenes"
        case .executeScene(let id): return "/scenes/\(id)/execute"
        }
    }
    
    private var method: String {
        switch self {
        case .listScenes: return "GET"
        case .executeScene(_): return "POST"
        }
    }
    
    private var url: URL? {
        return URL(string: "https://api.smartthings.com\(value)")
    }
}
