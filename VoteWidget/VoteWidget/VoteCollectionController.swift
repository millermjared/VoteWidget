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
    
    lazy var editorDialog: VoteDialogController = {
        let storyboard = UIStoryboard(name: "VoteWidget", bundle: Bundle(for: self.classForCoder))
        let result = storyboard.instantiateViewController(withIdentifier: "VoteDialog") as! VoteDialogController
        result.delegate = self
        return result
    }()
    
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
        editorDialog.vote = Vote()
        widgetContainer?.presentModalView(widget: self)
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

extension VoteCollectionController: VoteDialogDelegate {
    func voted(voteDialog: VoteDialogController) {
        widgetContainer?.dismissModalView(widget: self)
        
        if var eventPayload = sourceData {
            
            var widgetData = eventPayload["widgetData"] as! [[String:Any]]
            
            if let vote = voteDialog.vote {
                
                widgetData.append(vote.toJSON())
                
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

extension VoteCollectionController: DDSIOSWidget {
    
    public func currentModalViewController() -> UIViewController? {
        
        return editorDialog
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
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vote = votes?[indexPath.item] {
            editorDialog.vote = vote
            widgetContainer?.presentModalView(widget: self)
        }
    }
}

extension VoteCollectionController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return voteCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoteCell", for: indexPath) as! CompactViewVoteCell
        
        cell.vote = votes?[indexPath.item]
        
        return cell
    }
    
    
}

extension VoteCollectionController: UICollectionViewDelegateFlowLayout {
    
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width, height: 90.0)
        }
    
}
