//
//  ModuleInjection.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//

import UIKit
import RealmSwift

final class ModuleInjection: NSObject {
    typealias DashboardModules = (
        home: UIViewController,
        favorite: UIViewController,
        search: UIViewController
    )
    
    private static func provideRepository() -> GameRepositoryProtocol {
        let realm = try? Realm()
        
        let remote: RemoteDataSource = RemoteDataSource.shared(RemoteManager.sharedInstance())
        let locale: LocaleDataSource = LocaleDataSource.shared(realm)
        return GameRepository.shared(remote, locale)
    }
    
    static func provideDetai(with id: Int) -> UIViewController {
        let viewController = DetailGameViewController()
        
        let presenter: ViewToPresenterDetailGameProtocol & InteractorToPresenterDetailGameProtocol = DetailGamePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = DetailGameRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = DetailGameInteractor(repository: provideRepository())
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.id = id
        
        return viewController
    }
    
    static func provideAbout() -> UIViewController {
        let viewController = AboutViewController()
        let navigation = UINavigationController(rootViewController: viewController)

        let presenter: ViewToPresenterAboutProtocol & InteractorToPresenterAboutProtocol = AboutPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = AboutRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AboutInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return navigation
    }
    
    static func provideHome() -> UIViewController {
        let viewController = HomeViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        let presenter: ViewToPresenterHomeProtocol & InteractorToPresenterHomeProtocol = HomePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = HomeRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = HomeInteractor(repository: provideRepository())
        viewController.presenter?.interactor?.presenter = presenter
        
        return navigation
    }
    
    static func provideFavorite() -> UIViewController {
        let viewController = FavoriteViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        
        let presenter: ViewToPresenterFavoriteProtocol & InteractorToPresenterFavoriteProtocol = FavoritePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = FavoriteRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = FavoriteInteractor(repository: provideRepository())
        viewController.presenter?.interactor?.presenter = presenter
        
        return navigation
    }
    
    static func provideDashboard() -> UITabBarController {
        let subTabs = dashboardTabs(using: (
            home: provideHome(),
            favorite: provideFavorite(),
            search: provideSearch()
        ))
        let viewController = DashboardViewController(tabs: subTabs)
        let presenter: ViewToPresenterDashboardProtocol & InteractorToPresenterDashboardProtocol = DashboardPresenter()
        
        viewController.presenter =  presenter
        viewController.presenter?.router = DashboardRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = DashboardInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    static func provideSearch() -> UIViewController {
        let viewController = SearchViewController()
        let navigation = UINavigationController(rootViewController: viewController)

        let presenter: ViewToPresenterSearchProtocol & InteractorToPresenterSearchProtocol = SearchPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SearchRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SearchInteractor(repository: provideRepository())
        viewController.presenter?.interactor?.presenter = presenter
        
        return navigation
    }
}

extension ModuleInjection {
    private static func dashboardTabs(using submodules: DashboardModules) -> DashboardTabs {
        let homeTabBarItem = UITabBarItem (title: "Beranda", image: UIImage(systemName: "house.circle.fill"), tag: 11)
        let favoriteTabBarItem = UITabBarItem(title: "Favorit", image: UIImage(systemName: "heart.circle.fill"), tag: 12)
        let searchTabBarItem = UITabBarItem(title: "Cari", image: UIImage(systemName: "magnifyingglass.circle.fill"), tag: 13)
        submodules.home.tabBarItem = homeTabBarItem
        submodules.favorite.tabBarItem = favoriteTabBarItem
        submodules.search.tabBarItem = searchTabBarItem
        
        return (
            home: submodules.home,
            favorite: submodules.favorite,
            search: submodules.search
        )
    }
}
