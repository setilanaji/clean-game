//
//  AboutContract.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewAboutProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAboutProtocol {
    
    var view: PresenterToViewAboutProtocol? { get set }
    var interactor: PresenterToInteractorAboutProtocol? { get set }
    var router: PresenterToRouterAboutProtocol? { get set }
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAboutProtocol {
    
    var presenter: InteractorToPresenterAboutProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAboutProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAboutProtocol {
    
}
