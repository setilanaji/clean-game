//
//  DetailGamePresenter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation

class DetailGamePresenter: ViewToPresenterDetailGameProtocol {

    // MARK: Properties
    var view: PresenterToViewDetailGameProtocol?
    var interactor: PresenterToInteractorDetailGameProtocol?
    var router: PresenterToRouterDetailGameProtocol?
    
    func getGameDetail() {
        DispatchQueue.global(qos: .background).async {
            self.interactor?.getGameDetail()
        }
    }
    
    func viewDidLoad() {
        getGameDetail()
        getGameScreenshots()
    }
    
    func getGameScreenshots() {
        DispatchQueue.global(qos: .background).async {
            self.interactor?.getGameScreeenshots()
        }
    }
    
    func addToFavorite(with game: GameModel) {
        self.interactor?.addToFavorite(with: game)
    }
    
    func removeFromFavorite(with game: GameModel) {
        self.interactor?.removeFromFavorite(with: game)
    }
}

extension DetailGamePresenter: InteractorToPresenterDetailGameProtocol {
    
    func addToFavoriteSuccess(result: (Bool, String)) {
        view?.onAddToFavoriteSuccess(name: result.1)
    }
    
    func addToFavoriteFailure(error: APIError) {
        view?.onAddToFavoriteFailure(error: error.localizedDescription)
    }
    
    func removeFromFavoriteSuccess(result: (Bool, String)) {
        view?.onRemoveFromFavoriteSuccess(name: result.1)
    }
    
    func removeFromFavoriteFailure(error: APIError) {
        view?.onRemoveFromFavoriteFailure(error: error.localizedDescription)
    }
    
    func getGameFailure(error: APIError) {
        view?.onGetGameFailure(error: error.localizedDescription)
    }
    
    func getGameSuccess(result: GameModel) {
        view?.onGetGameSuccess(data: result)
    }
    
    func getGameScreenshotsSuccess(result: BaseModel<ScreenshotModel>) {
        view?.onGetGameScreenshotsSuccess(data: result.result)
    }
    
    func getGamgeScreenshotsFailure(error: APIError) {
        view?.onGetGameScreenshotFailure(error: error.localizedDescription)
    }
    
    func getSellingStoresFailure(error: String) {
        view?.onGetSellingStoresFailure(error: error)
    }
    
    func getSellingStoresSuccess(result: BaseModel<SellingStoreModel>) {
        view?.onGetSellingStoresSuccess(data: result.result)
    }
}
