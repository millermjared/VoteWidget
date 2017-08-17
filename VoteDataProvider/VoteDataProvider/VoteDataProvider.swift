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
    var voteData: [Any]? {
        didSet {
            startProducing()
        }
    }
    
    func loadStubData() {
        let bundle = Bundle(for: self.classForCoder)
        guard let path = bundle.path(forResource: "sample-json", ofType: "txt") else {
            return
        }
        
        let data: Data = try! NSData(contentsOfFile:path) as Data
        
        do {
            let sourceData = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any])
            
            voteData = sourceData?["widgetData"] as? [Any]
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
        
        var payload = [String: Any]()
        payload["widgetData"] = voteData
        BaseWidgetContainer.sharedInstance().publishEvent(withName: "VOTE_DATA_CHANGED", payload: payload)
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
            if let vote = payload["widgetData"] {
                voteData?.append(vote)
            }
            break;
        case "REMOVE_VOTE":
            if let vote = payload["widgetData"] as? [String: Any]{
                var index = 0
                for testVote in voteData! {
                    let jsonVote = testVote as! [String: Any]
                    if vote == jsonVote {
                        break
                    }
                    index = index + 1
                }
                
                voteData?.remove(at: index)
            }
            break;
        case "UPDATE_VOTE":
            if let vote = payload["widgetData"] as? [String: Any]{
                var index = 0
                for testVote in voteData! {
                    let jsonVote = testVote as! [String: Any]
                    
                    if vote["meetingGroupName"] as? String == jsonVote["meetingGroupName"] as? String {
                        break
                    }
                    index = index + 1
                }
                
                if index < (voteData?.count)! {
                    voteData?[index] = vote
                } else {
                    voteData?.append(vote)
                }
            }
            break;
        default:
            break
        }
    }
    
}

func ==(left: [String: Any], right: [String: Any]) -> Bool {
    for key in left.keys {
        if let leftValue = left[key] as? [String: Any] {
            if let rightValue = right[key] as? [String: Any] {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        } else if let leftValue = left[key] as? [Any] {
            if let rightValue = right[key] as? [Any] {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        } else if let leftValue = left[key] as? NSString {
            if let rightValue = right[key] as? NSString {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        } else if let leftValue = left[key] as? NSNumber {
            if let rightValue = right[key] as? NSNumber {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        }
    }
    return true
}

func ==(left: [Any], right: [Any]) -> Bool {
    if left.count != right.count {
        return false
    }
    
    for (index, element) in left.enumerated() {
        if let leftValue = element as? [String: Any] {
            if let rightValue = right[index] as? [String: Any] {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        } else if let leftValue = element as? NSString {
            if let rightValue = right[index] as? NSString {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        } else if let leftValue = element as? NSNumber {
            if let rightValue = right[index] as? NSNumber {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        } else if let leftValue = element as? [Any] {
            if let rightValue = right[index] as? [Any] {
                let comparison = leftValue == rightValue
                if !comparison {
                    return false
                }
            } else {
                return false
            }
        }
    }
    return true
}

