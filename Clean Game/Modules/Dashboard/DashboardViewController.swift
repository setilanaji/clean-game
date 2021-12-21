//
//  DashboardViewController.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import UIKit

typealias DashboardTabs = (
    home: UIViewController,
    favorite: UIViewController,
    search: UIViewController
)

class DashboardViewController: UITabBarController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterDashboardProtocol?
    
    init(tabs: DashboardTabs) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [tabs.home, tabs.favorite, tabs.search]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DashboardViewController: PresenterToViewDashboardProtocol{}

extension DashboardViewController {
    private func setupUI() {
        setTabAppereance()
    }
    
    private func setTabAppereance() {
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            self.navigationController?.navigationBar.isTranslucent = false
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            tabAppearance.backgroundColor = .white
            tabBar.standardAppearance = tabAppearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}
