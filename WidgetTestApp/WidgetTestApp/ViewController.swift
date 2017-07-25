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
import DDSWidget
import DDSIOSWidget

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        IOSWidgetContainer.registerWithContainer(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        
        guard let path = Bundle.main.path(forResource: "sample-json", ofType: "txt") else {
            return
        }
        
        let data: Data = try! NSData(contentsOfFile:path) as Data
        
        var payload: [String: Any]?
        do {
            payload = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any])
        } catch {
            print(error)
        }
        
        BaseWidgetContainer.sharedInstance().publishEvent(withName: "VOTE_DATA_CHANGED", payload: payload!)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "widget", for: indexPath) as! WidgetContainerCell
        
        if indexPath.item == 0 {
            
            let voteCollectionController = VoteWidgetProvider.createWidget()
            voteCollectionController.addWidgetToView(cell.contentArea, inController: self)
            
            cell.widget = voteCollectionController
            cell.barkerCount.text = "\(voteCollectionController.barkerCount())"
            cell.widgetTitle.text = voteCollectionController.widgetTitle()
            
        } else {
            let voteCollectionController = VoteChartWidgetProvider.createWidget()
            voteCollectionController.addWidgetToView(cell.contentArea, inController: self)
            
            cell.widget = voteCollectionController
            cell.barkerCount.text = "\(voteCollectionController.barkerCount())"
            cell.widgetTitle.text = voteCollectionController.widgetTitle()
        }
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.size.width, height: collectionView.frame.size.height / 2.0)
    }
    
}
