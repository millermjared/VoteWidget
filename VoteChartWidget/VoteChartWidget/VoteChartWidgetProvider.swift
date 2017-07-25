//
//  VoteChartWidgetProvider.swift
//  VoteChartWidget
//
//  Created by Matt Miller on 7/25/17.
//  Copyright © 2017 Matt Miller. All rights reserved.
//

import UIKit
import DDSWidget

public class VoteChartWidgetProvider: NSObject {

}

extension VoteChartWidgetProvider {
    public static func createWidget() -> VoteChartController {
        let storyboard = UIStoryboard(name: "VoteChart", bundle: Bundle(for: self))
        let widget = storyboard.instantiateViewController(withIdentifier: "VoteChartWidget") as! VoteChartController
        
        widget.setWidgetContainer(BaseWidgetContainer.sharedInstance())
        
        
        return widget
    }
}
