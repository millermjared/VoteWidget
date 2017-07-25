//
//  VoteCollectionController.swift
//  VoteWidget
//
//  Created by Matt Miller on 7/19/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit
import DDSWidget
import DDSIOSWidget

public class VoteCollectionController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    weak var widgetContainer: DDSWidgetContainer?
    
    var votingTitle: String?

    var voteCount: Int {
        get {
            return votes?.count ?? 0
        }
    }
    
    var votes: [Vote]?
    
    var sourceData: [String: Any]? {
        didSet {
            if let metadata = sourceData?["metadata"] as! [String: Any]? {
                votingTitle = metadata["title"] as! String?
            }
            
            if let widgetData = sourceData?["widgetData"] as! [[String:Any]]? {
                
                var newVotes = [Vote]()
                
                for singleVoteData in widgetData {
                    let vote = Vote(sourceData: singleVoteData)
                    newVotes.append(vote)
                }
                
                votes = newVotes
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFlowLayout.scrollDirection = .vertical
        widgetContainer?.subscribeToEvent(withName: "VOTE_DATA_CHANGED", subscriber: self)
    }

    @IBAction func addClicked(_ sender: Any) {
        if var eventPayload = sourceData {
            
            var widgetData = eventPayload["widgetData"] as! [[String:Any]]
            
            widgetData.append(["anotherVote": "just add"])
            
            eventPayload["widgetData"] = widgetData
            
            widgetContainer?.publishEvent(withName: "VOTE_DATA_CHANGED", payload: eventPayload)
        }
    }
    
    @IBAction func removeClicked(_ sender: Any) {
        if var eventPayload = sourceData {
            var widgetData = eventPayload["widgetData"] as! [[String:Any]]
            
            if widgetData.count > 0 {
                
                widgetData.remove(at: widgetData.count - 1)
                
                eventPayload["widgetData"] = widgetData
                
                widgetContainer?.publishEvent(withName: "VOTE_DATA_CHANGED", payload: eventPayload)
            }
        }
    }
    
}

extension VoteCollectionController: DDSWidget {
    
    public func setWidgetContainer(_ container: DDSWidgetContainer) {
        widgetContainer = container
    }

    public func widgetId() -> String {
        return "VoteWidget" //make this dynamic for multiple instances...
    }
    
    public func widgetTitle() -> String {
        return votingTitle ?? ""
    }
    
    public func barkerCount() -> Int32 {
        return Int32(voteCount)
    }
    
    public func layoutContent(forSize size: CGSize) {
        self.view.frame = CGRect(x:0, y:0, width: size.width, height: size.height)
        self.view.layoutIfNeeded()
    }
    
    public func currentModalView() -> Any {
        return currentModalViewController()
    }
    
}

extension VoteCollectionController: DDIOSWidget {
    
    public func currentModalViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "VoteWidget", bundle: Bundle(for: self.classForCoder))
        let widget = storyboard.instantiateViewController(withIdentifier: "VoteWidget") as! VoteCollectionController
        
        widget.setWidgetContainer(BaseWidgetContainer.sharedInstance())
        
        
        return widget
    }
}

extension VoteCollectionController: DDSEventSubscriber {
    public func process(name: String, payload: [String : Any]) {
        sourceData = payload
        collectionView.reloadData()
        widgetContainer?.publishEvent(withName: "CHROME_DATA_UPDATED", payload: [String: Any]())
    }
}

extension VoteCollectionController: UICollectionViewDelegate {
    
}

extension VoteCollectionController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return voteCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "VoteCell", for: indexPath)
    }
    
    
}

extension VoteCollectionController: UICollectionViewDelegateFlowLayout {
    
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width, height: 90.0)
        }
    
}
