//
//  DDSWidget.swift
//  DDSWidget
//
//  Created by Matt Miller on 7/19/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

public protocol DDSWidgetContainer: class {
    
    func register(component: DDSComponent)
    func registrationCompleted()
    
    func subscribeToEvent(withName eventName: String, subscriber: DDSEventSubscriber)
    func publishEvent(withName eventName: String, payload: [String: Any])
    func presentModalView(widget: DDSWidget)
    func dismissModalView(widget: DDSWidget)
}

public protocol DDSComponent {
    func componentId() -> String
    func register(inContainer container: DDSWidgetContainer)
}

public protocol DDSWidget: DDSComponent {
    func widgetTitle() -> String
    func barkerCount() -> Int32
    func layoutContent(width: Float32, height: Float32)
    func currentModalView() -> Any
}

public protocol DDSDataProvider: DDSComponent {
    func startProducing()
    func pauseProducing()
    func stopProducing()
}

public protocol DDSWidgetProvider {
    associatedtype Widget
    static func createWidget() -> Widget
}

public protocol DDSEventSubscriber {
    func process(name: String, payload: [String: Any])
}
