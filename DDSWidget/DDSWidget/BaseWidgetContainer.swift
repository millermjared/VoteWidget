//
//  BaseWidgetContainer.swift
//  DDSWidget
//
//  Created by Matt Miller on 7/24/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

open class BaseWidgetContainer: NSObject {
    
    static let singleton = BaseWidgetContainer()
    
    public static var sharedInstance: ()->DDSWidgetContainer = {
        return singleton
    }
    
    var subscribers: [String: [DDSEventSubscriber]]
    
    public override init() {
        subscribers = [String: [DDSEventSubscriber]]()
    }
    
    //dumb swift limitation requires this method not be implemented in an extension
    open func presentModalView(widget: DDSWidget) {
        fatalError("Must be implemented in a subclass")
    }
    
    open func dismissModalView(widget: DDSWidget) {
        fatalError("Must be implemented in a subclass")
    }
    
}

extension BaseWidgetContainer: DDSWidgetContainer {
    
    public func subscribeToEvent(withName eventName: String, subscriber: DDSEventSubscriber) {
        var eventSubscribers = subscribers[eventName]
        if eventSubscribers == nil {
            eventSubscribers = [DDSEventSubscriber]()
        }
        
        eventSubscribers!.append(subscriber)
        subscribers[eventName] = eventSubscribers!
    }
    
    public func publishEvent(withName eventName: String, payload: [String: Any]) {
        if let eventSubscribers = subscribers[eventName] {
            
            for subscriber in eventSubscribers {
                subscriber.process(name: eventName, payload: payload)
            }
        }
    }
}
