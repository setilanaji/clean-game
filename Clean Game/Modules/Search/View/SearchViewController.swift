//
//  SearchViewController.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//  
//

import UIKit

enum SearchControllerConstant {
    static let skeletonCount = 16
}

class SearchViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isLoading = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "Cari"
        presenter?.reset()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Properties
    var isLoading = true {
        didSet {
            collectionView.reloadData()
        }
    }
    var presenter: ViewToPresenterSearchProtocol?
    private let searchController = UISearchController(searchResultsController: nil)
    private var games: [GameModel] = []
    
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
    
    fileprivate var activityIndicator: LoadMoreIndicator!
    
}

extension SearchViewController {
    private func setupUI() {
        hideKeyboardWhenTappedAround()
        setupSearch()
        setupCollection()
        activityIndicator = LoadMoreIndicator(scrollView: collectionView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        activityIndicator.stop()
    }
    
    private func setupSearch() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari game"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupCollection() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = createCollectionLayout()
        
        let gameNib = UINib(nibName: SearchCollectionViewCell.identifier, bundle: nil)
        collectionView.register(gameNib, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        let skeletonNib = UINib(nibName: SkeletonSearchCollectionViewCell.identifier, bundle: nil)
        collectionView.register(skeletonNib, forCellWithReuseIdentifier: SkeletonSearchCollectionViewCell.identifier)
        
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
    
    func makeContextMenu(for game: GameModel) -> UIMenu {
        let share = UIAction(title: "Bagikan", image: UIImage(systemName: "square.and.arrow.up")) { action in
            self.shareGame(with: game.slug, name: game.name)
        }
        return UIMenu(title: "", children: [share])
    }
}

extension SearchViewController: PresenterToViewSearchProtocol{
    func onSearchSuccessReset(data: [GameModel]) {
        games.removeAll()
        games.append(contentsOf: data)
        isLoading = false
        DispatchQueue.main.async {
            self.activityIndicator.stop()
        }
    }
    
    func onSearchSuccess(dat: [GameModel]) {
        games.append(contentsOf: dat)
        isLoading = false
        DispatchQueue.main.async {
            self.activityIndicator.stop()
        }
    }
    
    func onSearchFailure(error: String) {
        showMessage(of: .error, title: "Gagal", subtitle: error)
        isLoading = false
    }
    
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
    
}

// MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else {
            return
        }
        isLoading = true
        presenter?.searchGames(for: text, reset: true)
        games.removeAll()
    }

    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if !isLoading {
            let game = self.games[indexPath.row]

            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                return self.makeContextMenu(for: game)
            })
        } else {
            return nil
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let searchBar = searchController.searchBar
        searchBar.resignFirstResponder()
        if !isLoading {
            activityIndicator.start {
                DispatchQueue.global(qos: .utility).async {
                    self.presenter?.loadMore()
                }
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !isLoading {
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath ) as? SearchCollectionViewCell
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
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonSearchCollectionViewCell.identifier, for: indexPath ) as? SkeletonSearchCollectionViewCell
            else { preconditionFailure("invalid cell type") }
            cell.configure()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !isLoading ? games.count : SearchControllerConstant.skeletonCount
    }
    
}
