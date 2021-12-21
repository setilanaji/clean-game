//
//  SearchInteractor.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//  
//

import Foundation
import RxSwift

class SearchInteractor: PresenterToInteractorSearchProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterSearchProtocol?
    
    private let repository: GameRepositoryProtocol
    private var disposeBag = DisposeBag()
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func searchGames(
        for keyword: String,
        in page: Int
    ) {
        repository.getGames(in: page, request: GameRequest(search: keyword))
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.searchSuccess(result: result)
            } onError: { error in
                self.presenter?.searchFailure(error: error.localizedDescription)
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
            } onCompleted: {}
            .disposed(by: disposeBag)
    }
}
