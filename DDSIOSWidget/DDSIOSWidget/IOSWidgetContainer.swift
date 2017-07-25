//
//  IOSWidgetContainer.swift
//  DDSIOSWidget
//
//  Created by Matt Miller on 7/25/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit
import DDSWidget

public class IOSWidgetContainer: BaseWidgetContainer {

    static var singleton = IOSWidgetContainer()
    
    public static func register() {
        self.sharedInstance = {
            return singleton
        }
    }
    
}
