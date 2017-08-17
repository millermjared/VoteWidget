//
//  VoteChartWidgetProvider.swift
//  VoteChartWidget
//
//  Created by Matt Miller on 7/25/17.
//  Copyright © 2017 Matt Miller. All rights reserved.
//

import UIKit
import DDSWidget

public class VoteChartWidgetProvider: DDSWidgetProvider {
    public typealias Widget = VoteChartController

    public static func createWidget() -> Widget {
        let storyboard = UIStoryboard(name: "VoteChart", bundle: Bundle(for: self))
        let widget = storyboard.instantiateViewController(withIdentifier: "VoteChartWidget") as! Widget
        
        widget.register(inContainer: BaseWidgetContainer.sharedInstance())
        
        
        return widget
    }
}
