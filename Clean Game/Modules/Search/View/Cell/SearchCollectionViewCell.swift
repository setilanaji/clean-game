//
//  SearchCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//

import UIKit
import Cosmos

class SearchCollectionViewCell: UICollectionViewCell {

    static let identifier = "SearchCollectionViewCell"
    
    @IBOutlet weak var gameThumbnail: RoundImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var gameGenre: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    var tapItem: ((Int) -> Void)?
    var tapFavorite: ((GameModel, Bool) -> Void)?
    
    private var isFavorite = false {
        didSet{
            DispatchQueue.main.async {
                self.changeFavoriteUI()
            }
        }
    }
    
    private var game: GameModel? {
        didSet {
            guard let game = game else {
                return
            }
            gameTitle.text = game.name
            gameGenre.text = game.released.toDate().toString(format: "dd MMMM yyyy")
            gameThumbnail.setImage(with: game.backgroundImage)
            isFavorite = game.isFavorite
            ratingView.rating = Double(game.rating)
        }
    }
    
    func set(data: GameModel) {
        self.game = data
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
            self.changeLocal(isFavorite: self.isFavorite)
        }
    }
    
    private func changeFavoriteUI() {
        if self.isFavorite {
            self.favoriteButton.tintColor = .red
        } else {
            self.favoriteButton.tintColor = .systemGray4
        }
    }
    
    private func changeLocal(isFavorite: Bool){
        guard let game = game else {
            return
        }
        self.tapFavorite?(game, isFavorite)
    }
}
