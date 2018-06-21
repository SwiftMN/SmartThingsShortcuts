//
//  PagedResult.swift
//  SmartThingsShortcuts
//
//  Created by Steven Vlaminck on 6/8/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import Foundation

struct Link: Decodable {
    let href: String
}

struct Links: Decodable {
    let next: Link?
    let previous: Link?
}

struct PagedResult<U: Decodable>: Decodable {
    let items: [U]
    let _links: Links?
    
    var nextRequest: URLRequest? {
        guard
            let links = _links,
            let next = links.next,
            let url = URL(string: next.href)
        else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
