//
//  AboutPresenter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation

class AboutPresenter: ViewToPresenterAboutProtocol {

    // MARK: Properties
    var view: PresenterToViewAboutProtocol?
    var interactor: PresenterToInteractorAboutProtocol?
    var router: PresenterToRouterAboutProtocol?
}

extension AboutPresenter: InteractorToPresenterAboutProtocol {
    
}
