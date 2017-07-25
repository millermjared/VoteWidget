//
//  Vote.swift
//  VoteWidget
//
//  Created by Matt Miller on 7/24/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

enum VoteDecision {
    case abstained
    case inFavor
    case against
}

struct Vote {
    
    var votingDocumentTitle: String?
    var meetingGroupName: String?
    var decision: VoteDecision = .abstained
    
    init(sourceData: [String: Any]) {
        meetingGroupName = sourceData["meetingGroupName"] as! String?
        
        let decisionString = sourceData["decision"] as! String?
        
        if "for" == decisionString {
            decision = .inFavor
        } else if "against" == decisionString {
            decision = .against
        } else {
            decision = .abstained
        }
        
    }
    
    init() {
    }
    
    func toJSON() -> [String: Any] {
        var data = [String: Any]()
        data["meetingGroupName"] = meetingGroupName ?? ""
        switch decision {
        case .inFavor:
            data["decision"] = "for"
        case .against:
            data["decision"] = "against"
        default:
            data["decision"] = "abstain"
        }
        
        return data
    }
}
