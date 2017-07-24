//
//  BaseWidgetContainer.swift
//  DDSWidget
//
//  Created by Matt Miller on 7/24/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

@objc public class BaseWidgetContainer: NSObject {
    
    public static let sharedInstance = BaseWidgetContainer()
    
    var subscribers: [DDSEventSubscriber]
    
    override init() {
        subscribers = [DDSEventSubscriber]()
    }
}

extension BaseWidgetContainer: DDSWidgetContainer {
    
    public func subscribeToEvent(withName eventName: String, subscriber: DDSEventSubscriber) {
        subscribers.append(subscriber)
    }
    
    public func publishEvent(withName eventName: String, payload: [String: Any]) {
        for subscriber in subscribers {
            subscriber.process(name: eventName, payload: payload)
        }
    }
}
