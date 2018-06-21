//
//  Response.swift
//  SmartThingsShortcuts
//
//  Created by Steven Vlaminck on 6/8/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import Foundation

enum Response<Decodable> {
    case success(Decodable)
    case error(Error)
}
