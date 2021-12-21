//
//  DetailGameViewController.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import UIKit
import Cosmos
import SwiftMessages
import SafariServices
import Kingfisher

enum DetailGameConstant {
    static let itemPerRow: CGFloat = 4
    static let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    static let skeletonCount = 4
}

class DetailGameViewController: UIViewController {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    let gameTitleBarLayer = CAGradientLayer()
    
    @IBOutlet weak var gameThumbnail: RoundImageView!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameReview: UILabel!
    @IBOutlet weak var checkButton: RoundButtonView!
    @IBOutlet weak var screenshotView: UIView!
    @IBOutlet weak var gameDescription: UILabel!
    let gameDescriptionBarLayer = CAGradientLayer()
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var genres: UILabel!
    let gameGenresBarLayer = CAGradientLayer()
    
    @IBOutlet weak var favoriteButton: UIImageView!
    
    private let screenshotsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 220)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 20, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    lazy var shareItem: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(shareGameTap(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        return barButton
    }()
    
    private var game: GameModel? {
        didSet {
            guard let game = game else {
                return
            }
            set(game: game)
        }
    }
    
    private var isFavorite = false {
        didSet{
            DispatchQueue.main.async {
                self.changeFavoriteUI()
            }
        }
    }
    
    private var sellingStores: [SellingStoreModel] = []
    
    private var screenshots = [ScreenshotModel]() {
        didSet {
            screenshotsCollection.reloadData()
        }
    }
    
    private var screenshotsIsloaded = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterDetailGameProtocol?
    
}

extension DetailGameViewController {
    private func setupUI() {
        setNavigation()
        setScreenshots()
        setSkeleton()
        setFavorite()
    }
    
    private func setNavigation() {
        navigationItem.rightBarButtonItems = [self.shareItem]
    }
    
    private func setFavorite() {
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFavoriteButton(_:))))
    }
    
    private func set(game: GameModel) {
        removeSkeleton()
        headerImage.setImage(with: game.backgroundImage)
        gameTitle.text = game.name
        gameRating.text = String(game.rating)
        gameThumbnail.setImage(with: game.backgroundImage)
        gameDescription.text = game.description.isEmpty ? "-" : game.description
        gameReview.text = "\(game.reviewsCount) ulasan"
        ratingView.rating = Double(game.rating)
        genres.text = game.genres.map { $0.name }.joined(separator: ", ")
        gameDescription.setContentCompressionResistancePriority(.required, for: .vertical)
        checkButton.isEnabled = !game.stores.isEmpty
        isFavorite = game.isFavorite
    }
    
    private func setScreenshots() {
        screenshotsCollection.delegate = self
        screenshotsCollection.dataSource = self
        
        let cellNib = UINib(nibName: ScreenshotsCollectionViewCell.identifier, bundle: nil)
        screenshotsCollection.register(cellNib, forCellWithReuseIdentifier: ScreenshotsCollectionViewCell.identifier)
        let skeletoncellNib = UINib(nibName: SkeletonScreenshotCollectionViewCell.identifier, bundle: nil)
        screenshotsCollection.register(skeletoncellNib, forCellWithReuseIdentifier: SkeletonScreenshotCollectionViewCell.identifier)
        screenshotView.addSubview(screenshotsCollection)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        screenshotsCollection.anchor(top: screenshotView.topAnchor, paddingTop: 0, bottom: screenshotView.bottomAnchor, paddingBottom: 0, left: screenshotView.leadingAnchor, paddingLeft: 0, right: screenshotView.trailingAnchor, paddingRight: 0, width: 0, height: 200)
    }
    
    func makeContextMenu(for screenshot: ScreenshotModel) -> UIMenu {
        let share = UIAction(title: "Bagikan", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
            if let url = URL(string: screenshot.image) {
                KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url, cacheKey: nil), options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        let items = [value.image]
                        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        self?.present(ac, animated: true)
                    case .failure(let error):
                        self?.showMessage(of: .error, title: "Terjadi kesalahan", subtitle: "\(error)")
                    }
                }
            }
        }
        return UIMenu(title: "", children: [share])
    }
    
    @IBAction private func getGameTap(_ sender: Any) {
        checkButton.showAnimation {
            self.showStores(with: self.game?.stores ?? [])
        }
    }
    
    @objc private func shareGameTap(_ sender: Any) {
        guard let game = self.game else {
            return
        }
        shareGame(with: game.slug, name: game.name)
    }
    
    func openFrom(link url: String) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }
    }
    
    private func showStores(with data: [BaseStoreModel]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            data.forEach { store in
                alert.addAction(UIAlertAction(title: store.store.name, style: .default , handler:{ (UIAlertAction)in
                    guard let selling = self.sellingStores.first(where: { $0.id == store.id}) else {
                        self.openFrom(link: "https://" + store.store.domain)
                        SwiftMessages.hideAll()
                        return
                    }
                    self.openFrom(link: selling.url)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Batalkan", style: .cancel, handler:{ (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
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
        if isFavorite {
            presenter?.addToFavorite(with: game)
        } else {
            presenter?.removeFromFavorite(with: game)
        }
    }
}

extension DetailGameViewController: SkeletonLoadable {
    private func setSkeleton() {
        gameDescriptionBarLayer.frame = CGRect(x: 0, y: 0, width: gameDescription.bounds.width * 0.6, height: gameDescription.bounds.height)
        gameDescriptionBarLayer.cornerRadius = gameTitle.frame.height / 2
        
        gameTitleBarLayer.frame = CGRect(x: 0, y: 0, width: gameTitle.bounds.width * 0.6, height: gameTitle.bounds.height)
        gameTitleBarLayer.cornerRadius = gameTitle.frame.height / 2
        
        gameGenresBarLayer.frame = CGRect(x: 0, y: 0, width: genres.bounds.width * 0.6, height: genres.bounds.height)
        gameGenresBarLayer.cornerRadius = genres.frame.height / 2
        
        [gameTitleBarLayer, gameGenresBarLayer, gameDescriptionBarLayer].forEach {
            $0.startPoint = CGPoint(x: 0, y: 0.5)
            $0.endPoint = CGPoint(x: 1, y: 0.5)
        }
        gameTitle.layer.addSublayer(gameTitleBarLayer)
        genres.layer.addSublayer(gameGenresBarLayer)
        gameDescription.layer.addSublayer(gameDescriptionBarLayer)
        
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        [gameTitleBarLayer, gameGenresBarLayer, gameDescriptionBarLayer].forEach { $0.add(animationGroup, forKey: "backgroundColor") }
    }
    
    private func removeSkeleton() {
        [gameTitle, genres, gameDescription].forEach {
            $0?.layer.sublayers?.removeAll()
        }
    }
}

extension DetailGameViewController: PresenterToViewDetailGameProtocol{
    
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
    
    func onGetSellingStoresFailure(error: String) {}
    
    func onGetSellingStoresSuccess(data: [SellingStoreModel]) {
        sellingStores = data
    }
    
    func onGetGameFailure(error: String) {
        showMessage(of: .error, title: "Gagal", subtitle: error)
    }
    
    func onGetGameSuccess(data: GameModel) {
        game = data
    }
    
    func onGetGameScreenshotFailure(error: String) { screenshotView.isHidden = true }
    
    func onGetGameScreenshotsSuccess(data: [ScreenshotModel]) {
        screenshotsIsloaded = true
        screenshots = data
        screenshotView.isHidden = data.isEmpty
    }
}

extension DetailGameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DetailGameConstant.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if screenshotsIsloaded {
            let game = self.screenshots[indexPath.row]
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                return self.makeContextMenu(for: game)
            })
        } else {
            return nil
        }
    }
}

extension DetailGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotsIsloaded ? screenshots.count : DetailGameConstant.skeletonCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.8, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if screenshotsIsloaded {
            guard let cell = self.screenshotsCollection.dequeueReusableCell(withReuseIdentifier: ScreenshotsCollectionViewCell.identifier, for: indexPath ) as? ScreenshotsCollectionViewCell
            else { preconditionFailure("invalid cell type") }
            let game = self.screenshots[indexPath.row]
            cell.configure()
            cell.set(data: game)
            cell.layer.cornerRadius = 8
            return cell
        } else {
            guard let cell = self.screenshotsCollection.dequeueReusableCell(withReuseIdentifier: SkeletonScreenshotCollectionViewCell.identifier, for: indexPath ) as? SkeletonScreenshotCollectionViewCell
            else { preconditionFailure("invalid cell type") }
            cell.configure()
            return cell
        }
    }
}

