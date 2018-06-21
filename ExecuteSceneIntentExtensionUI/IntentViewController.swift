//
//  IntentViewController.swift
//  ExecuteSceneIntentExtensionUI
//
//  Created by Steven Vlaminck on 6/10/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        
        
        guard let intent = interaction.intent as? ExecuteSceneIntent else {
            🐛("interaction.intent NOT ExecuteSceneIntent")
            completion(false, parameters, self.desiredSize)
            return
        }
        
        imageView.image = Icon(iconName: intent.sceneIcon).image
//        imageView.backgroundColor = hexStringToUIColor(hex: intent.sceneColor)
        let sceneName = intent.sceneName ?? "Scene"
        label.text = "Execute \(sceneName)"
        
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
//        return self.extensionContext!.hostedViewMaximumAllowedSize
        return CGSize(width: 320, height: 150)
    }
    
    
    func hexStringToUIColor(hex: String?) -> UIColor? {
        guard let hex = hex else {
            return nil
        }
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
