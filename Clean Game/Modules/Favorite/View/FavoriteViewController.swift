//
//  FavoriteViewController.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import UIKit

enum FavoriteControllerConstant {
    static let skeletonCount = 16
}

class FavoriteViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorit"
        presenter?.getFavorites()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterFavoriteProtocol?
    
    private var isLoaded = false
    private var games: [GameModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.isLoaded = !self.games.isEmpty
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
}

extension FavoriteViewController {
    
    private func setupUI() {
        view.backgroundColor = .colorBackground
        setupCollection()
    }
    
    private func setupCollection() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = createCollectionLayout()
        
        let gameNib = UINib(nibName: FavoriteCollectionViewCell.identifier, bundle: nil)
        collectionView.register(gameNib, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        let skeletonNib = UINib(nibName: SkeletonfavoriteCollectionViewCell.identifier, bundle: nil)
        collectionView.register(skeletonNib, forCellWithReuseIdentifier: SkeletonfavoriteCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    func createCollectionLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated((view.frame.width * 0.2) + 24)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoaded {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath ) as? FavoriteCollectionViewCell
            else { preconditionFailure("invalid cell type") }
            let game = self.games[indexPath.row]
            cell.configure()
            cell.set(data: game)
            cell.tapFavorite = { (game, isFavorite) in
                if isFavorite {
                    self.presenter?.addToFavorite(with: game)
                } else {
                    self.presenter?.removeFromFavorite(with: game)
                }
            }
            cell.tapItem = { id in
                self.presenter?.tapGame(with: id)
            }
            cell.layer.cornerRadius = 8
            cell.layoutIfNeeded()
            return cell
        } else {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonfavoriteCollectionViewCell.identifier, for: indexPath ) as? SkeletonfavoriteCollectionViewCell
            else { preconditionFailure("invalid cell type") }
            cell.configure()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoaded ? games.count : FavoriteControllerConstant.skeletonCount
    }
    
}

extension FavoriteViewController: PresenterToViewFavoriteProtocol{
    func onAddToFavoriteSuccess(name: String) {
        showMessage(of: .success, title: "Berhasil", subtitle: "\(name) berhasil ditambah ke favorit")
    }
    
    func onAddToFavoriteFailure(error: String) {
        showMessage(of: .error, title: "Gagal", subtitle: error)
    }
    
    func onRemoveFromFavoriteSuccess(name: String) {
        showMessage(of: .success, title: "Berhasil", subtitle: "\(name) berhasil dihapus dari favorit")
    }
    
    func onRemoveFromFavoriteFailure(error: String) {
        showMessage(of: .error, title: "Gagal", subtitle: error)
    }
    
    func onGetFavoritesSuccess(data: [GameModel]) {
        games = data
    }
    
    func onGetFavoritesFailure(error: String) {
        showMessage(of: .error, title: "Gagal", subtitle: error)
    }
}
