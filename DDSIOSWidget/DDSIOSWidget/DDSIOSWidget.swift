//
//  DDSIOSWidget.swift
//  DDSIOSWidget
//
//  Created by Matt Miller on 7/21/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit
import DDSWidget

public extension DDSWidget where Self: UIViewController {
    public func addWidgetToView(_ parentView: UIView, inController controller: UIViewController) {
        controller.addChildViewController(self)
        parentView.addSubview(view)
    }
}

public protocol DDSIOSWidget: DDSWidget {
    func currentModalViewController() -> UIViewController
}
