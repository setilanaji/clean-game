//
//  SkeletonSearchCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//

import UIKit

class SkeletonSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SkeletonSearchCollectionViewCell"
    
    @IBOutlet weak var gameThumbnail: RoundImageView!
    let gameThumbnailBarLayer = CAGradientLayer()

    @IBOutlet weak var gameTitle: UILabel!
    let gameTitleBarLayer = CAGradientLayer()
    
    @IBOutlet weak var gameDate: UILabel!
    let gameDateBarLayer = CAGradientLayer()

    func configure() {
        gameThumbnailBarLayer.frame = gameThumbnail.bounds
        gameThumbnailBarLayer.cornerRadius = 8
        
        gameTitleBarLayer.frame = CGRect(x: 0, y: 0, width: gameTitle.bounds.width * 0.6, height: gameTitle.bounds.height)
        gameTitleBarLayer.cornerRadius = gameTitle.frame.height / 2
        
        gameDateBarLayer.frame = CGRect(x: 0, y: 0, width: gameDate.bounds.width * 0.6, height: gameDate.bounds.height)
        gameDateBarLayer.cornerRadius = gameDate.frame.height / 2
        
        [gameThumbnailBarLayer, gameDateBarLayer, gameTitleBarLayer].forEach {
            $0.startPoint = CGPoint(x: 0, y: 0.5)
            $0.endPoint = CGPoint(x: 1, y: 0.5)
        }
        gameThumbnail.layer.addSublayer(gameThumbnailBarLayer)
        gameDate.layer.addSublayer(gameDateBarLayer)
        gameTitle.layer.addSublayer(gameTitleBarLayer)
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        [gameThumbnailBarLayer, gameDateBarLayer, gameTitleBarLayer].forEach { $0.add(animationGroup, forKey: "backgroundColor") }
    }
}

extension SkeletonSearchCollectionViewCell: SkeletonLoadable {}
