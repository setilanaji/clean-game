//
//  SearchContract.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewSearchProtocol {
    func onSearchSuccessReset(data: [GameModel])
    func onSearchSuccess(dat: [GameModel])
    func onSearchFailure(error: String)
    
    func onAddToFavoriteSuccess(name: String)
    func onAddToFavoriteFailure(error: String)
    
    func onRemoveFromFavoriteSuccess(name: String)
    func onRemoveFromFavoriteFailure(error: String)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSearchProtocol {
    
    var view: PresenterToViewSearchProtocol? { get set }
    var interactor: PresenterToInteractorSearchProtocol? { get set }
    var router: PresenterToRouterSearchProtocol? { get set }
    
    func searchGames(for keyword: String, reset: Bool)
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
    func loadMore()
    func reset()
    func tapGame(with id: Int)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSearchProtocol {
    
    var presenter: InteractorToPresenterSearchProtocol? { get set }
    func searchGames(for keyword: String, in page: Int)
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSearchProtocol {
    func searchSuccess(result: BaseModel<GameModel>)
    func searchFailure(error: String)
    
    func addToFavoriteSuccess(result: (Bool, String))
    func addToFavoriteFailure(error: String)
    
    func removeFromFavoriteSuccess(result: (Bool, String))
    func removeFromFavoriteFailure(error: String)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSearchProtocol {
    func toDetail(with id: Int, on view: PresenterToViewSearchProtocol)
}
