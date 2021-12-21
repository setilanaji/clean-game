//
//  FavoriteCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/2.
//

import UIKit
import Cosmos

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteCollectionViewCell"

    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameThumbnail: RoundImageView!
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var gameSubtitle: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    private var game: GameModel? {
        didSet {
            guard let game = game else {
                return
            }
            gameTitle.text = game.name
            gameThumbnail.setImage(with: game.backgroundImage)
            gameSubtitle.text = game.released.toDate().toString(format: "dd MMMM yyyy")
            isFavorite = game.isFavorite
            ratingView.rating = Double(game.rating)
        }
    }
    
    var tapItem: ((Int) -> Void)?
    var tapFavorite: ((GameModel, Bool) -> Void)?

    private var isFavorite = false {
        didSet{
            DispatchQueue.main.async {
                self.changeFavoriteUI()
            }
        }
    }
    
    func set(data: GameModel) {
        game = data
    }
    
    func configure() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGame(_:))))
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFavoriteButton(_:))))
    }
    
    @objc private func tapGame(_ sender: Any) {
        contentView.showAnimation {
            guard let id = self.game?.id else {
                return
            }
            self.tapItem?(id)
        }
    }
    
    @objc private func tapFavoriteButton(_ sender: Any) {
        favoriteButton.showAnimation {
                self.isFavorite = !self.isFavorite
                self.changeLocal()
        }
    }
    
    private func changeFavoriteUI() {
        if self.isFavorite {
            self.favoriteButton.tintColor = .red
        } else {
            self.favoriteButton.tintColor = .systemGray4
        }
    }
    
    private func changeLocal(){
        guard let game = game else {
            return
        }
        self.tapFavorite?(game, isFavorite)
    }

}
