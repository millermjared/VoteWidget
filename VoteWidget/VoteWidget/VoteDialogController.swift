//
//  VoteDialogControllerViewController.swift
//  VoteWidget
//
//  Created by Matt Miller on 7/25/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit

protocol VoteDialogDelegate: class {
    func voted(voteDialog: VoteDialogController)
}

class VoteDialogController: UIViewController {

    @IBOutlet weak var meetingGroupName: UITextField!
    
    public var vote: Vote?
    public weak var delegate: VoteDialogDelegate?
    
    public override func viewWillAppear(_ animated: Bool) {
        meetingGroupName.text = vote?.meetingGroupName ?? ""
    }
    
    func updateVote() {
        vote?.meetingGroupName = meetingGroupName.text
    }
    
    @IBAction func voteFor(_ sender: Any) {
        updateVote()
        vote?.decision = .inFavor
        delegate?.voted(voteDialog: self)
    }
    
    @IBAction func voteAgainst(_ sender: Any) {
        updateVote()
        vote?.decision = .against
        delegate?.voted(voteDialog: self)
    }
    
    @IBAction func abstain(_ sender: Any) {
        updateVote()
        vote?.decision = .abstained
        delegate?.voted(voteDialog: self)
    }
    
    
}
