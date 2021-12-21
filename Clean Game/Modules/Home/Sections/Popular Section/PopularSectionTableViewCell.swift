//
//  PopularSectionTableViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/16.
//

import UIKit

enum PopularSectionConstant {
    static let itemPerRow: CGFloat = 4
    static let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    static let skeletonCount = 4
}

class PopularSectionTableViewCell: UITableViewCell {
    
    static let identifier = "PopularSectionTableViewCell"

    private var isLoaded = false
        
    private var games: [GameModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.isLoaded = !self.games.isEmpty
                self.collectionView.reloadData()
            }
        }
    }
    
    var shareHandler: ((String, String) -> Void)?
    var onTapGameItem: ((Int) -> Void)?
    var onTapFavorite: ((GameModel, Bool) -> Void)?

    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Game Terbaik"
        label.textColor = .label
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        return label
    }()
    
    private let collectionView: UICollectionView

    func configure(with data: [GameModel]) {
        self.games = data
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 220)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 20, right: 16)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .colorBackground
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        let cellNib = UINib(nibName: PopularCollectionViewCell.identifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        let skeletoncellNib = UINib(nibName: SkeletonPopularCollectionViewCell.identifier, bundle: nil)
        collectionView.register(skeletoncellNib, forCellWithReuseIdentifier: SkeletonPopularCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headerView.addSubview(titleLabel)
        contentView.addSubview(headerView)
        contentView.addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.anchor(top: headerView.topAnchor, paddingTop: 0, bottom: headerView.bottomAnchor, paddingBottom: 0, left: headerView.leadingAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: 0, height: 0)
        
        headerView.anchor(top: contentView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: 0, right: contentView.trailingAnchor, paddingRight: 0, width: 0, height: 40)
        
        collectionView.anchor(top: headerView.bottomAnchor, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: 0, right: contentView.trailingAnchor, paddingRight: 0, width: 0, height: 260)
    }
    
    func makeContextMenu(for game: GameModel) -> UIMenu {
        let share = UIAction(title: "Bagikan", image: UIImage(systemName: "square.and.arrow.up")) { action in
            self.shareHandler?(game.name, game.slug)
        }
        return UIMenu(title: "", children: [share])
    }
}

extension PopularSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width * 0.8, height: 220)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return GenreSectionConstant.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if isLoaded {
            let game = self.games[indexPath.row]

            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                return self.makeContextMenu(for: game)
            })
        } else {
            return nil
        }
    }
}

extension PopularSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoaded ? games.count : PopularSectionConstant.skeletonCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoaded {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.identifier, for: indexPath ) as? PopularCollectionViewCell
                else { preconditionFailure("invalid cell type") }
            let game = self.games[indexPath.row]
            cell.configure()
            cell.set(data: game)
            cell.layer.cornerRadius = 8
            cell.tapItem = onTapGameItem
            cell.tapFavorite = onTapFavorite
            return cell
        } else {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonPopularCollectionViewCell.identifier, for: indexPath ) as? SkeletonPopularCollectionViewCell
                else { preconditionFailure("invalid cell type") }
            cell.configure()
            return cell
        }
    }
}

