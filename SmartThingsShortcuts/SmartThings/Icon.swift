//
//  SceneIcon.swift
//  SmartThingsShortcuts
//
//  Created by Steven Vlaminck on 6/8/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import Foundation
import UIKit

enum Icon: String {
    case wand =  "st.scenes.wand"
    case bedTime = "st.scenes.bedtime"
    case movieTime = "st.scenes.popcorn"
    case partyTime = "st.scenes.party_time"
    case readingTime = "st.scenes.reading"
    case romantic = "st.scenes.romantic"
    case relax = "st.scenes.relax"
    case sunset = "st.scenes.sunset"
    case twilight = "st.scenes.twilight"
    case wakeup = "st.scenes.wakeup"
    
    init(iconName: String?) {
        self = iconName.flatMap { Icon(rawValue: $0) } ?? .wand
    }

    var image: UIImage {
        switch self {
        case .wand: return #imageLiteral(resourceName: "wand")
        case .bedTime: return #imageLiteral(resourceName: "bedtime")
        case .movieTime: return #imageLiteral(resourceName: "movieTime")
        case .partyTime: return #imageLiteral(resourceName: "partyTime")
        case .readingTime: return #imageLiteral(resourceName: "readingTime")
        case .romantic: return #imageLiteral(resourceName: "romantic")
        case .relax: return #imageLiteral(resourceName: "relax")
        case .sunset: return #imageLiteral(resourceName: "sunset")
        case .twilight: return #imageLiteral(resourceName: "twilight")
        case .wakeup: return #imageLiteral(resourceName: "wakeup")
        }
    }
    
    var smallImage: UIImage {
        switch self {
        case .wand: return #imageLiteral(resourceName: "wandSmall")
        case .bedTime: return #imageLiteral(resourceName: "bedTimeSmall")
        case .movieTime: return #imageLiteral(resourceName: "movieTimeSmall")
        case .partyTime: return #imageLiteral(resourceName: "partyTimeSmall")
        case .readingTime: return #imageLiteral(resourceName: "readingTimeSmall")
        case .romantic: return #imageLiteral(resourceName: "romanticSmall")
        case .relax: return #imageLiteral(resourceName: "relaxSmall")
        case .sunset: return #imageLiteral(resourceName: "sunsetSmall")
        case .twilight: return #imageLiteral(resourceName: "twilightSmall")
        case .wakeup: return #imageLiteral(resourceName: "wakeupSmall")
        }
    }
}
