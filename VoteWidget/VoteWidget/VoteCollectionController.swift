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
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    override public func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFlowLayout.scrollDirection = .vertical
    }

}

extension VoteCollectionController: DDSWidget {
    public func widgetTitle() -> String {
        return "Voting Items"
    }
    
    public func barkerCount() -> Int32 {
        return 12
    }
    
    public func layoutContent(forSize size: CGSize) {
        self.view.frame = CGRect(x:0, y:0, width: size.width, height: size.height)
        self.view.layoutIfNeeded()
    }
}

extension VoteCollectionController: UICollectionViewDelegate {
    
}

extension VoteCollectionController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
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
