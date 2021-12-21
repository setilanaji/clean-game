//
//  FavoritePresenter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation

class FavoritePresenter: ViewToPresenterFavoriteProtocol {

    // MARK: Properties
    var view: PresenterToViewFavoriteProtocol?
    var interactor: PresenterToInteractorFavoriteProtocol?
    var router: PresenterToRouterFavoriteProtocol?
    
    func getFavorites() {
        interactor?.getFavorites()
    }
    
    func addToFavorite(with game: GameModel) {
        interactor?.addToFavorite(with: game)
    }
    
    func removeFromFavorite(with game: GameModel) {
        interactor?.removeFromFavorite(with: game)
    }
    
    func tapGame(with id: Int) {
        router?.toDetail(with: id, on: view!)
    }
}

extension FavoritePresenter: InteractorToPresenterFavoriteProtocol {
    func getFavoritesFailure(error: String) {
        view?.onGetFavoritesFailure(error: error)
    }
    
    func getFavoritesSuccess(data: [GameModel]) {
        view?.onGetFavoritesSuccess(data: data)
    }
    
    func addToFavoriteFailure(error: String) {
        view?.onAddToFavoriteFailure(error: error)
    }
    
    func addToFavoriteSuccess(result: (Bool, String)) {
        view?.onAddToFavoriteSuccess(name: result.1)
    }
    
    func removeFromFavoriteFailure(error: String) {
        view?.onRemoveFromFavoriteFailure(error: error)
    }
    
    func removeFromFavoriteSuccess(result: (Bool, String)) {
        if result.0 {
            view?.onRemoveFromFavoriteSuccess(name: result.1)
        } else {
            view?.onRemoveFromFavoriteFailure(error: "tidak dapat melakukan operasi")
        }
    }
}
