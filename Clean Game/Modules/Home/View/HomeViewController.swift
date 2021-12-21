//
//  HomeViewController.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import UIKit

class HomeViewController: UIViewController {
    
    private var isLoading = false {
        didSet {
            if isLoading {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Clean Game"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
        navigationItem.rightBarButtonItem = profileItem
        presenter?.getLastestGames(in: 1)
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterHomeProtocol?
    
    private let defaultSections: [HomeCell] = [.popularSection(models: [], rows: 1), .newestSection(models: [], rows: 1)]
    
    var models: [HomeCell] = [.popularSection(models: [], rows: 1), .newestSection(models: [], rows: 1)] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var profileItem: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(tapProfile(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        return barButton
    }()
    
    private let refreshControl = UIRefreshControl()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.contentInset = .zero
        table.backgroundColor = .colorBackground
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        let genresNib = UINib(nibName: GenreSectionTableViewCell.identifier, bundle: nil)
//        table.register(genresNib, forCellReuseIdentifier: GenreSectionTableViewCell.identifier)
        table.register(PopularSectionTableViewCell.self, forCellReuseIdentifier: PopularSectionTableViewCell.identifier)
        table.register(NewestSectionTableViewCell.self, forCellReuseIdentifier: NewestSectionTableViewCell.identifier)
        table.tableHeaderView = nil
        table.tableFooterView = nil
        table.separatorColor = .clear
        table.separatorInset = .zero
        return table
    }()
}

extension HomeViewController {
    private func setupUI() {
        setupTableView()
        setupRefreshControl()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshGames(_:)), for: .valueChanged)
        refreshControl.tintColor = .systemGray4
    }
    
    @objc private func refreshGames(_ sender: Any) {
        models = [.popularSection(models: [], rows: 1), .newestSection(models: [], rows: 1)]
        getData()
    }
    
    private func getData() {
        isLoading = true
        presenter?.viewDidLoad()
        presenter?.getLastestGames(in: 1)
    }
    
    @objc func tapProfile(_ sender: Any) {
        presenter?.toProfile()
    }
}

extension HomeViewController: PresenterToViewHomeProtocol{
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
    
    func onGetGamesSuccess(data: [GameModel]) {
        DispatchQueue.main.async {
            self.isLoading = false
            if let index = self.models.firstIndex(where: { element in
                if case .popularSection = element {
                    return true
                } else {
                    return false
                }
            }) {
                self.models[index] = .popularSection(models: data, rows: 1)
            }
        }
    }
    
    func onGetGamesFailure(error: String) {
        isLoading = false
    }
    
    func onGeLastestGamesFailure(error: String) {
        isLoading = false
    }
    
    func onGetLastestGamesSuccess(data: [GameModel]) {
        DispatchQueue.main.async {
            self.isLoading = false
            if let index = self.models.firstIndex(where: { element in
                if case .newestSection = element {
                    return true
                } else {
                    return false
                }
            }) {
                self.models[index] = .newestSection(models: data, rows: 1)
            }
        }
    }
}
