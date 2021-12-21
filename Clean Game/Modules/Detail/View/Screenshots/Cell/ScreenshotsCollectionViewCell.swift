//
//  ScreenshotsCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/5.
//

import UIKit

class ScreenshotsCollectionViewCell: UICollectionViewCell {

    static let identifier = "ScreenshotsCollectionViewCell"
    
    @IBOutlet weak var gameThumbnail: RoundImageView!
    
    var tapItem: ((Int) -> Void)?
    
    private var game: ScreenshotModel? {
        didSet {
            guard let game = game else {
                return
            }
            gameThumbnail.setImage(with: game.image)
        }
    }
    
    func set(data: ScreenshotModel) {
        self.game = data
    }
    
    func configure() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGame(_:))))
    }
    
    @objc private func tapGame(_ sender: Any) {
        contentView.showAnimation {
            guard let id = self.game?.id else {
                return
            }
            self.tapItem?(id)
        }
    }

}

extension ScreenshotsCollectionViewCell: SkeletonLoadable {}
