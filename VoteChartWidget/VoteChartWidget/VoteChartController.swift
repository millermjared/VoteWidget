//
//  VoteChartController.swift
//  VoteChartWidget
//
//  Created by Matt Miller on 7/25/17.
//  Copyright © 2017 Matt Miller. All rights reserved.
//

import UIKit
import DDSWidget
import DDSIOSWidget

public class VoteChartController: UIViewController {

    weak var widgetContainer: DDSWidgetContainer?
    var segments: [Segment]?
    
    @IBOutlet weak var pieChartView: PieChartView!
    
}

extension VoteChartController: DDSWidget {
    public func componentId() -> String {
        return "VoteChartWidget" //make this dynamic for multiple instances...
    }

    public func register(inContainer container: DDSWidgetContainer) {
        widgetContainer = container
        widgetContainer?.subscribeToEvent(withName: "VOTE_DATA_CHANGED", subscriber: self)
    }
    
    public func widgetTitle() -> String {
        return componentId()
    }
    
    public func barkerCount() -> Int32 {
        return Int32(1)
    }
    
    public func layoutContent(width: Float32, height: Float32) {
        self.view.frame = CGRect(x:0, y:0, width: CGFloat(width), height: CGFloat(height))
        self.view.layoutIfNeeded()
    }
    
    public func currentModalView() -> Any {
        return currentModalViewController() as Any
    }
    
}

extension VoteChartController: DDSIOSWidget {
    
    public func currentModalViewController() -> UIViewController? {
        
        return nil
    }
}

extension VoteChartController: DDSEventSubscriber {
    public func process(name: String, payload: [String : Any]) {

        
        if let widgetData = payload["widgetData"] as! [[String:Any]]? {
            
            var votedFor = 0
            var against = 0
            var notVoted = 0
            var total = 0
            
            for sourceData in widgetData {
                let decisionString = sourceData["decision"] as! String?
                
                if "for" == decisionString {
                    votedFor = votedFor + 1
                } else if "against" == decisionString {
                    against = against + 1
                } else {
                    notVoted = notVoted + 1
                }
                total = total + 1
            }
            
            segments = [Segment(color: UIColor.red, value: CGFloat(against)/CGFloat(total), label: "No"), Segment(color: UIColor.green, value: CGFloat(votedFor)/CGFloat(total), label: "Yes"), Segment(color: UIColor.gray, value: CGFloat(notVoted)/CGFloat(total), label: "Not Voted")]
            
            if let pieChart = pieChartView, let chartData = segments {
                pieChart.segments = chartData
                
                pieChart.setNeedsDisplay()
            }
            
        }
        
        
    }
}
