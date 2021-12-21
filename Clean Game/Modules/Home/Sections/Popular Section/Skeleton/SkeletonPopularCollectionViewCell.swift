//
//  SkeletonPopularCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/29.
//

import UIKit

class SkeletonPopularCollectionViewCell: UICollectionViewCell {

    static let identifier = "SkeletonPopularCollectionViewCell"

    @IBOutlet weak var backgroundImage: RoundImageView!
    let backgroundImageLayer = CAGradientLayer()
    
    func configure() {
        backgroundImage.cornerRadius = 8
        
        backgroundImageLayer.frame = backgroundImage.bounds
        backgroundImageLayer.cornerRadius = 8
        
        backgroundImageLayer.startPoint = CGPoint(x: 0, y: 0.5)
        backgroundImageLayer.endPoint = CGPoint(x: 1, y: 0.5)
        backgroundImage.layer.addSublayer(backgroundImageLayer)
        
        let backgroundImageGroup = makeAnimationGroup()
        backgroundImageGroup.beginTime = 0.0
        backgroundImageLayer.add(backgroundImageGroup, forKey: "backgroundColor")
    }
}

extension SkeletonPopularCollectionViewCell: SkeletonLoadable {}
