//
//  VoteWidgetProvider.swift
//  VoteWidget
//
//  Created by Matt Miller on 7/21/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit
import DDSWidget
import DDSIOSWidget

public class VoteWidgetProvider: NSObject {
    
}

extension VoteWidgetProvider {
    public static func createWidget() -> VoteCollectionController {
        let storyboard = UIStoryboard(name: "VoteWidget", bundle: Bundle(for: self))
        let widget = storyboard.instantiateViewController(withIdentifier: "VoteWidget") as! VoteCollectionController
        
        widget.register(inContainer: BaseWidgetContainer.sharedInstance())
        
        return widget
    }
}
