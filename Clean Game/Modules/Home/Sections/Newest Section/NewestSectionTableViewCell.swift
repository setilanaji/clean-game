//
//  NewestSectionTableViewCell.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/16.
//

import UIKit

enum NewestSectionConstant {
    static let itemPerRow: CGFloat = 1
    static let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    static let skeletonCount = 8
}

class NewestSectionTableViewCell: UITableViewCell {
    
    static let identifier = "NewestSectionTableViewCell"
    
    private var isLoaded = false
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var shareHandler: ((String, String) -> Void)?
    var onTapGameItem: ((Int) -> Void)?
    var onTapFavorite: ((GameModel, Bool) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Game Terbaru"
        label.textColor = .label
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        return label
    }()
    
    private lazy var collectionView: DynamicCollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        let collectionView = DynamicCollectionView(frame: contentView.bounds, collectionViewLayout: listLayout)
        
        contentView.backgroundColor = .colorBackground
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private var games: [GameModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.isLoaded = !self.games.isEmpty
                self.collectionView.reloadData()
            }
        }
    }
    
    func configure(with data: [GameModel]) {
        self.games = data
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headerView.addSubview(titleLabel)
        contentView.addSubview(headerView)
        contentView.addSubview(collectionView)
        
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated((contentView.frame.width * 0.2) + 24)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        
        let gameNib = UINib(nibName: NewestCollectionViewCell.identifier, bundle: nil)
        collectionView.register(gameNib, forCellWithReuseIdentifier: NewestCollectionViewCell.identifier)
        let skeletonNib = UINib(nibName: SkeletonNewestCollectionViewCell.identifier, bundle: nil)
        collectionView.register(skeletonNib, forCellWithReuseIdentifier: SkeletonNewestCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.anchor(top: headerView.topAnchor, paddingTop: 0, bottom: headerView.bottomAnchor, paddingBottom: 0, left: headerView.leadingAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: 0, height: 0)
        
        headerView.anchor(top: contentView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: 0, right: contentView.trailingAnchor, paddingRight: 0, width: 0, height: 40)
        
        collectionView.anchor(top: headerView.bottomAnchor, paddingTop: 8, bottom: contentView.bottomAnchor, paddingBottom: 8, left: contentView.leadingAnchor, paddingLeft: 0, right: contentView.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    func makeContextMenu(for game: GameModel) -> UIMenu {
        let share = UIAction(title: "Bagikan", image: UIImage(systemName: "square.and.arrow.up")) { action in
            self.shareHandler?(game.name, game.slug)
        }
        return UIMenu(title: "", children: [share])
    }

}

extension NewestSectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: false)
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

extension NewestSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoaded ? games.count : NewestSectionConstant.skeletonCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoaded {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: NewestCollectionViewCell.identifier, for: indexPath ) as? NewestCollectionViewCell
            else { preconditionFailure("invalid cell type") }
            let game = self.games[indexPath.row]
            cell.configure()
            cell.set(data: game)
            cell.layer.cornerRadius = 8
            cell.layoutIfNeeded()
            cell.tapItem = onTapGameItem
            cell.tapFavorite = onTapFavorite
            return cell
        } else {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonNewestCollectionViewCell.identifier, for: indexPath ) as? SkeletonNewestCollectionViewCell
            else { preconditionFailure("invalid cell type") }
            cell.configure()
            return cell
        }
    }
    
}
