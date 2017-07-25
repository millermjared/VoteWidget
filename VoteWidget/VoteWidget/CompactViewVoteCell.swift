//
//  CompactViewVoteCell.swift
//  VoteWidget
//
//  Created by Matt Miller on 7/19/17.
//  Copyright © 2017 Diligent, Inc. All rights reserved.
//

import UIKit

class CompactViewVoteCell: UICollectionViewCell {
    
    @IBOutlet weak var voteStatusLabel: UILabel!
    @IBOutlet weak var voteIcon: UIImageView!
    @IBOutlet weak var meetingGroupName: UILabel!
    
    public var vote: Vote? {
        didSet {
            
            
            let bundle = Bundle(for: self.classForCoder)
//                return UIImage(named: "YourImageName", in: bundle, compatibleWith: nil)

            
            
            switch vote!.decision {
            case VoteDecision.abstained:
                voteIcon.image = UIImage.init(named: "vote_in_progress", in:bundle, compatibleWith: nil)
                voteStatusLabel.text = "You have 1 pending vote."
                voteStatusLabel.textColor = UIColor.black
            case VoteDecision.inFavor:
                voteIcon.image = UIImage.init(named: "voted_for", in:bundle, compatibleWith: nil)
                voteStatusLabel.text = "You voted for."
                voteStatusLabel.textColor = UIColor.green
            case VoteDecision.against:
                voteIcon.image = UIImage.init(named: "voted_against", in:bundle, compatibleWith: nil)
                voteStatusLabel.text = "You voted against."
                voteStatusLabel.textColor = UIColor.red
            default:
                voteIcon.image = UIImage.init(named: "vote_in_progress", in:bundle, compatibleWith: nil)
                voteStatusLabel.text = "You have 1 pending vote."
                voteStatusLabel.textColor = UIColor.black
            }
            
            meetingGroupName.text = vote?.meetingGroupName

        }
    }
    
}
