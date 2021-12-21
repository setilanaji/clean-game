//
//  GenreCollectionViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/28.
//

import UIKit
import SwiftMessages

class GenreCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GenreCollectionViewCell"
    
    @IBOutlet weak var genreImage: RoundImageView!
    @IBOutlet weak var genreName: UILabel!
    @IBOutlet weak var backgroundImage: CornerRoundingView!

    var genre: GenreModel? {
        didSet {
            guard let genre = genre else {
                return
            }
            genreName.text = genre.name
            genreImage.image = genre.type.icon()
            backgroundImage.backgroundColor = .cyan
            backgroundImage.cornerRadius = contentView.frame.width / 2
        }
    }
    
    func set(data: GenreModel) {
        self.genre = data
    }
}
