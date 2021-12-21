//
//  SkeletonScreenshotCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/5.
//

import UIKit

class SkeletonScreenshotCollectionViewCell: UICollectionViewCell {

    static let identifier = "SkeletonScreenshotCollectionViewCell"

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

extension SkeletonScreenshotCollectionViewCell: SkeletonLoadable {}
