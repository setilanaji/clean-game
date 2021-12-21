//
//  DetailGameContract.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewDetailGameProtocol {
    func onGetGameSuccess(data: GameModel)
    func onGetGameFailure(error: String)
    
    func onGetGameScreenshotsSuccess(data: [ScreenshotModel])
    func onGetGameScreenshotFailure(error: String)
    
    func onGetSellingStoresSuccess(data: [SellingStoreModel])
    func onGetSellingStoresFailure(error: String)
    
    func onAddToFavoriteSuccess(name: String)
    func onAddToFavoriteFailure(error: String)
    
    func onRemoveFromFavoriteSuccess(name: String)
    func onRemoveFromFavoriteFailure(error: String)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterDetailGameProtocol {
    
    var view: PresenterToViewDetailGameProtocol? { get set }
    var interactor: PresenterToInteractorDetailGameProtocol? { get set }
    var router: PresenterToRouterDetailGameProtocol? { get set }
    
    func getGameDetail()
    func viewDidLoad()
    func getGameScreenshots()
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorDetailGameProtocol {
    
    var presenter: InteractorToPresenterDetailGameProtocol? { get set }
    var id: Int? { get set }
    
    func getGameDetail()
    func getGameScreeenshots()
    func getGameStores(with id: Int)
    func addToFavorite(with game: GameModel)
    func removeFromFavorite(with game: GameModel)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterDetailGameProtocol {
    func getGameSuccess(result: GameModel)
    func getGameFailure(error: APIError)
    
    func getGameScreenshotsSuccess(result: BaseModel<ScreenshotModel>)
    func getGamgeScreenshotsFailure(error: APIError)
    
    func getSellingStoresSuccess(result: BaseModel<SellingStoreModel>)
    func getSellingStoresFailure(error: String)
    
    func addToFavoriteSuccess(result: (Bool, String))
    func addToFavoriteFailure(error: APIError)
    
    func removeFromFavoriteSuccess(result: (Bool, String))
    func removeFromFavoriteFailure(error: APIError)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterDetailGameProtocol {
    
}
