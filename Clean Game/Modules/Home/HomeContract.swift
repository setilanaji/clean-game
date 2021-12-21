//
//  HomeContract.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewHomeProtocol: AnyObject {
    func onGetGamesSuccess(data: [GameModel])
    func onGetGamesFailure(error: String)
    
    func onGetLastestGamesSuccess(data: [GameModel])
    func onGeLastestGamesFailure(error: String)
    
    func onAddToFavoriteSuccess(name: String)
    func onAddToFavoriteFailure(error: String)
    
    func onRemoveFromFavoriteSuccess(name: String)
    func onRemoveFromFavoriteFailure(error: String)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterHomeProtocol: AnyObject {
    
    var view: PresenterToViewHomeProtocol? { get set }
    var interactor: PresenterToInteractorHomeProtocol? { get set }
    var router: PresenterToRouterHomeProtocol? { get set }
    
    func viewDidLoad()
    func getGames(in page: Int)
    func getLastestGames(in page: Int)
    func tapGame(with id: Int)
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
    func toProfile()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorHomeProtocol: AnyObject {
    
    var presenter: InteractorToPresenterHomeProtocol? { get set }
    
    func getPopularGames(in page: Int)
    func getLastestGames(in page: Int)
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterHomeProtocol: AnyObject {
    func getPopularGamesSuccess(result: BaseModel<GameModel>)
    func getPopularGamesFailure(error: APIError)
    
    func getLastestGamesSuccess(result: BaseModel<GameModel>)
    func getLastestGamesFailure(error: APIError)
    
    func addToFavoriteSuccess(result: (Bool, String))
    func addToFavoriteFailure(error: APIError)
    
    func removeFromFavoriteSuccess(result: (Bool, String))
    func removeFromFavoriteFailure(error: APIError)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterHomeProtocol: AnyObject {
    func toDetail(with id: Int, on view: PresenterToViewHomeProtocol)
    func toProfile(on view: PresenterToViewHomeProtocol)
}
