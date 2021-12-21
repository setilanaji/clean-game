//
//  FavoriteContract.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewFavoriteProtocol {
    func onGetFavoritesSuccess(data: [GameModel])
    func onGetFavoritesFailure(error: String)
    
    func onAddToFavoriteSuccess(name: String)
    func onAddToFavoriteFailure(error: String)
    
    func onRemoveFromFavoriteSuccess(name: String)
    func onRemoveFromFavoriteFailure(error: String)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterFavoriteProtocol {
    
    var view: PresenterToViewFavoriteProtocol? { get set }
    var interactor: PresenterToInteractorFavoriteProtocol? { get set }
    var router: PresenterToRouterFavoriteProtocol? { get set }
    
    func getFavorites()
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
    func tapGame(with id: Int)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorFavoriteProtocol {
    
    var presenter: InteractorToPresenterFavoriteProtocol? { get set }
    func getFavorites()
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterFavoriteProtocol {
    func getFavoritesSuccess(data: [GameModel])
    func getFavoritesFailure(error: String)
    
    func addToFavoriteSuccess(result: (Bool, String))
    func addToFavoriteFailure(error: String)
    
    func removeFromFavoriteSuccess(result: (Bool, String))
    func removeFromFavoriteFailure(error: String)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterFavoriteProtocol {
    func toDetail(with id: Int, on view: PresenterToViewFavoriteProtocol)
}
