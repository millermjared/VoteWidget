//
//  ViewController.swift
//  WidgetTestApp
//
//  Created by Matt Miller on 7/19/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit
import VoteWidget
import VoteChartWidget
import VoteDataProvider
import DDSWidget
import DDSIOSWidget

class ViewController: UIViewController {

    var widgets = [String: DDSIOSWidget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        IOSWidgetContainer.registerWithContainer(self)
        
        let voteCollectionController = VoteWidgetProvider.createWidget()
        widgets[voteCollectionController.componentId()] = voteCollectionController
        
        let voteChartController = VoteChartWidgetProvider.createWidget()
        widgets[voteChartController.componentId()] = voteChartController
        
        let voteDataProvider = VoteDataProvider()
        
        voteDataProvider.register(inContainer: BaseWidgetContainer.sharedInstance())
        
        BaseWidgetContainer.sharedInstance().registrationCompleted()
    }

}

extension ViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "widget", for: indexPath) as! WidgetContainerCell
        
        if indexPath.item == 0 {
            
            let voteCollectionController = widgets["VoteWidget"]!
            voteCollectionController.addWidgetToView(cell.contentArea, inController: self)
            
            cell.widget = voteCollectionController
            cell.barkerCount.text = "\(voteCollectionController.barkerCount())"
            cell.widgetTitle.text = voteCollectionController.widgetTitle()
            
        } else {

            let voteChartController = widgets["VoteChartWidget"]!
            voteChartController.addWidgetToView(cell.contentArea, inController: self)
            
            cell.widget = voteChartController
            cell.barkerCount.text = "\(voteChartController.barkerCount())"
            cell.widgetTitle.text = voteChartController.widgetTitle()
        }
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.size.width, height: collectionView.frame.size.height / 2.0)
    }
    
}
