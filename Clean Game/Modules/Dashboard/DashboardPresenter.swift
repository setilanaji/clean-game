//
//  DashboardPresenter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation

class DashboardPresenter: ViewToPresenterDashboardProtocol {

    // MARK: Properties
    var view: PresenterToViewDashboardProtocol?
    var interactor: PresenterToInteractorDashboardProtocol?
    var router: PresenterToRouterDashboardProtocol?
}

extension DashboardPresenter: InteractorToPresenterDashboardProtocol {
    
}
