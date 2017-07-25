//
//  WidgetContainerCell.swift
//  WidgetTestApp
//
//  Created by Matt Miller on 7/19/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit
import DDSWidget

class WidgetContainerCell: UICollectionViewCell {
    
    @IBOutlet weak var contentArea: UIView!
    @IBOutlet weak var barkerCount: UILabel!
    @IBOutlet weak var widgetTitle: UILabel!
    
    
    var widget: DDSWidget? {
        didSet {
            BaseWidgetContainer.sharedInstance().subscribeToEvent(withName: "CHROME_DATA_UPDATED", subscriber: self)
        }
    }
}

extension WidgetContainerCell: DDSEventSubscriber {
    public func process(name: String, payload: [String : Any]) {
        barkerCount.text = "\(widget!.barkerCount())"
        widgetTitle.text = widget!.widgetTitle()
    }
}
