//
//  DDSWidget.swift
//  DDSWidget
//
//  Created by Matt Miller on 7/19/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

public protocol DDSWidgetContainer: class {
    
    func subscribeToEvent(withName eventName: String, subscriber: DDSEventSubscriber)
    func publishEvent(withName eventName: String, payload: [String: Any])
}

public protocol DDSWidget {
    
    func setWidgetContainer(_ container: DDSWidgetContainer)
    
    func widgetTitle() -> String
    func barkerCount() -> Int32
    func layoutContent(forSize size: CGSize)
    
}

public protocol DDSWidgetProvider {
    static func createWidget() -> DDSWidget
}

public protocol DDSEventSubscriber {
    func process(name: String, payload: [String: Any])
}
