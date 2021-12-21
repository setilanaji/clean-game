//
//  PopularCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/29.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PopularCollectionViewCell"
    
    @IBOutlet weak var gameThumbnail: RoundImageView!
    @IBOutlet weak var gameTItle: UILabel!
    
    var tapItem: ((Int) -> Void)?
    var tapFavorite: ((GameModel, Bool) -> Void)?
    
    private var game: GameModel? {
        didSet {
            guard let game = game else {
                return
            }
            gameThumbnail.setImage(with: game.backgroundImage)
        }
    }
    
    func set(data: GameModel) {
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
