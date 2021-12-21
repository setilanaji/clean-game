//
//  SkeletonGenreCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/28.
//

import UIKit
import SwiftMessages

class SkeletonGenreCollectionViewCell: UICollectionViewCell {

    static let identifier = "SkeletonGenreCollectionViewCell"
    
    @IBOutlet weak var categoryName: UILabel!
    let categoryNameLayer = CAGradientLayer()

    @IBOutlet weak var backgroundImage: CornerRoundingView!
    let backgroundImageLayer = CAGradientLayer()
    
    @IBOutlet weak var image: UIImageView!
    
    var data: GenreModel? {
        didSet {
            guard let category = data else {
                return
            }
            categoryName.text = category.name
        }
    }
    
    func configure() {
        backgroundImage.cornerRadius = image.frame.height / 2
        
        categoryNameLayer.frame = categoryName.bounds
        categoryNameLayer.cornerRadius = categoryName.bounds.height / 2

        backgroundImageLayer.frame = image.bounds
        backgroundImageLayer.cornerRadius = image.frame.width / 2

        categoryNameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        categoryNameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        categoryName.layer.addSublayer(categoryNameLayer)
        
        backgroundImageLayer.startPoint = CGPoint(x: 0, y: 0.5)
        backgroundImageLayer.endPoint = CGPoint(x: 1, y: 0.5)
        backgroundImage.layer.addSublayer(backgroundImageLayer)
        
        let categoryNameGroup = makeAnimationGroup()
        categoryNameGroup.beginTime = 0.0
        categoryNameLayer.add(categoryNameGroup, forKey: "backgroundColor")

        let backgroundImageGroup = makeAnimationGroup()
        backgroundImageGroup.beginTime = 0.0
        backgroundImageLayer.add(backgroundImageGroup, forKey: "backgroundColor")
    }
}

extension SkeletonGenreCollectionViewCell: SkeletonLoadable {}
