//
//  VoteDataProvider.swift
//  VoteDataProvider
//
//  Created by Matt Miller on 7/26/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import DDSWidget

public class VoteDataProvider: NSObject, DDSDataProvider {
    weak var widgetContainer: DDSWidgetContainer?
    var voteData: [String: Any]?
    
    func loadStubData() {
        let bundle = Bundle(for: self.classForCoder)
        guard let path = bundle.path(forResource: "sample-json", ofType: "txt") else {
            return
        }
        
        let data: Data = try! NSData(contentsOfFile:path) as Data
        
        do {
            voteData = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any])
        } catch {
            print(error)
        }
    }
    
    public func componentId() -> String {
        return "VoteDataProvider"
    }
    
    public func register(inContainer container: DDSWidgetContainer) {
        widgetContainer = container
        loadStubData()
        widgetContainer?.subscribeToEvent(withName: "ADD_VOTE", subscriber: self)
        widgetContainer?.subscribeToEvent(withName: "REMOVE_VOTE", subscriber: self)
        widgetContainer?.subscribeToEvent(withName: "UPDATE_VOTE", subscriber: self)
        widgetContainer?.register(component: self as DDSDataProvider)
    }
    
    public func startProducing() {
        BaseWidgetContainer.sharedInstance().publishEvent(withName: "VOTE_DATA_CHANGED", payload: voteData!)
    }
    
    public func pauseProducing() {
        
    }
    
    public func stopProducing() {
        
    }
    
}

extension VoteDataProvider: DDSEventSubscriber {
    public func process(name: String, payload: [String: Any]) {
        switch name {
        case "ADD_VOTE":
            break;
        default:
            break
        }
    }
    
}
