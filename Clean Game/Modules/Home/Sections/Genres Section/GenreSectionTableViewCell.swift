//
//  GenreSectionTableViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/16.
//

import UIKit

enum GenreSectionConstant {
    static let itemPerRow: CGFloat = 4
    static let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    static let skeletonCount = 4
}

class GenreSectionTableViewCell: UITableViewCell {
    
    static let identifier = "GenreSectionTableViewCell"
    
    var categoryActionHandler: ((Int, String, String) -> Void)?
    var seeAllHandler: ((Int) -> Void)?
    
    var isLoaded = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var genres: [GenreModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.isLoaded = !self.genres.isEmpty
                self.collectionView.reloadData()
            }
        }
    }

    func configure(with data: [GenreModel]) {
        self.createCollectionView()
        self.genres = data
    }
    
    func createCollectionView() {
        self.collectionView.isScrollEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        contentView.backgroundColor = .colorBackground

        collectionView.backgroundColor = .clear
        
        let nib = UINib(nibName: GenreCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        let skeletonNib = UINib(nibName: SkeletonGenreCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(skeletonNib, forCellWithReuseIdentifier: SkeletonGenreCollectionViewCell.identifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
}

extension GenreSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = GenreSectionConstant.sectionInsets.left * (GenreSectionConstant.itemPerRow + 1)
        let availableWidth = contentView.frame.width - paddingSpace
        let widthPerItem = availableWidth / GenreSectionConstant.itemPerRow
        return CGSize(width: widthPerItem * 0.9, height: widthPerItem * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return GenreSectionConstant.sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return GenreSectionConstant.sectionInsets.left
    }
}

extension GenreSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoaded ? genres.count : GenreSectionConstant.skeletonCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoaded {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath ) as? GenreCollectionViewCell
                else { preconditionFailure("invalid cell type") }
            let genre = self.genres[indexPath.row]
            cell.set(data: genre)
            return cell
        } else {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonGenreCollectionViewCell.identifier, for: indexPath ) as? SkeletonGenreCollectionViewCell
                else { preconditionFailure("invalid cell type") }
            cell.configure()
            return cell
        }
    }
}
