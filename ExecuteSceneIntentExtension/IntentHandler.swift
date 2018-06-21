//
//  IntentHandler.swift
//  ExecuteSceneIntentExtension
//
//  Created by Steven Vlaminck on 6/10/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        🐛("handler(for intent: INIntent")
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        🐛("resolveRecipients(for intent: INSendMessageIntent")
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INPersonResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INPersonResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INPersonResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        }
    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        🐛("resolveContent(for intent: INSendMessageIntent")
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        🐛("confirm(intent: INSendMessageIntent")
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        🐛("handle(intent: INSendMessageIntent")
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        🐛("handle(intent: INSearchForMessagesIntent")
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        🐛("handle(intent: INSetMessageAttributeIntent")
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}

extension IntentHandler: ExecuteSceneIntentHandling {
    func confirm(intent: ExecuteSceneIntent, completion: @escaping (ExecuteSceneIntentResponse) -> Void) {
        guard intent.sceneId != nil && intent.sceneName != nil else {
            completion(ExecuteSceneIntentResponse(code: .ready, userActivity: nil))
            return
        }
        let readyOrNot: ExecuteSceneIntentResponseCode = intent.sceneId != nil ? .ready : .failure
        let response = ExecuteSceneIntentResponse(code: readyOrNot, userActivity: nil)
        🐛("confirm(intent: \(intent), readyOrNot: \(readyOrNot.rawValue)")
        completion(response)
    }
    
    func handle(intent: ExecuteSceneIntent, completion: @escaping (ExecuteSceneIntentResponse) -> Void) {
        🐛("handle(intent: \(intent))")
        guard let sceneId = intent.sceneId, let sceneName = intent.sceneName else {
            💩("intent was missing id and name")
            completion(ExecuteSceneIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        SmartThings.API.executeScene(id: sceneId) { response in
            switch response {
            case .success(_):
                🏅("successfully executed scene while handling intent")
                let response = ExecuteSceneIntentResponse.success(sceneName: sceneName)
                🐛(response)
                completion(response)
            case .error(let e):
                💩("failed to execute scene while handling intent; \(e)")
                let response = ExecuteSceneIntentResponse.failure(sceneName: sceneName)
                🐛(response)
                completion(response)
            }
        }
    }
}
