//
//  FavoriteInteractor.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation
import RxSwift

class FavoriteInteractor: PresenterToInteractorFavoriteProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterFavoriteProtocol?
    private let repository: GameRepositoryProtocol
    private var disposeBag = DisposeBag()
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getFavorites() {
        repository.getFavorites()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.getFavoritesSuccess(data: result)
            } onError: { error in
                self.presenter?.getFavoritesFailure(error: error.localizedDescription)
            } onCompleted: {}
            .disposed(by: disposeBag)
    }
    
    func addToFavorite(with game: GameModel) {
        repository.addFavoriteGame(with: game)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.addToFavoriteSuccess(result: result)
            } onError: { error in
                self.presenter?.addToFavoriteFailure(error: error.localizedDescription)
            } onCompleted: {}
            .disposed(by: disposeBag)
    }
    
    func removeFromFavorite(with game: GameModel) {
        repository.removeFavoriteGame(with: game)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.removeFromFavoriteSuccess(result: result)
            } onError: { error in
                self.presenter?.removeFromFavoriteFailure(error: error.localizedDescription)
            } onCompleted: {
                self.getFavorites()
            }
            .disposed(by: disposeBag)
    }
}
