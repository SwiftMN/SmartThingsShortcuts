//
//  Scene.swift
//  SmartThingsShortcuts
//
//  Created by Steven Vlaminck on 6/8/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import Foundation
import UIKit

struct Scene: Decodable {
    let sceneId: String
    let sceneName: String
    let sceneIcon: String
    var image: UIImage? {
        return Icon(iconName: sceneIcon).image
    }
}
