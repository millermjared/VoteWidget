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
    
    public var containerViewController: UIViewController?
    
    public static func registerWithContainer(_ containerVC: UIViewController) {
        self.sharedInstance = {
            return singleton
        }
        singleton.containerViewController = containerVC
    }
    
    override public func presentModalView(widget: DDSWidget) {
        let iosWidget = widget as! DDSIOSWidget
        
        let modalVC = iosWidget.currentModalViewController()
        modalVC.modalPresentationStyle = .formSheet
        containerViewController?.present(modalVC, animated: true, completion: nil)
    }
    
    override public func dismissModalView(widget: DDSWidget) {
        guard containerViewController?.presentedViewController == widget.currentModalView() as? UIViewController else {
            return
        }
        
        containerViewController?.dismiss(animated: true, completion: nil)
    }
    
}
