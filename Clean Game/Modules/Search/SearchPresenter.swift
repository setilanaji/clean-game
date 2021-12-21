//
//  SearchPresenter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//  
//

import Foundation

class SearchPresenter: ViewToPresenterSearchProtocol {
    
    // MARK: Properties
    var view: PresenterToViewSearchProtocol?
    var interactor: PresenterToInteractorSearchProtocol?
    var router: PresenterToRouterSearchProtocol?
    
    private var searchTask: DispatchWorkItem?
    private var currentPage = 1
    private var isLastPage = false
    private var currentKey = ""
    private var isReset = false
    
    func searchGames(for keyword: String, reset: Bool = false) {
        self.searchTask?.cancel()
        self.isReset = reset
        let task = DispatchWorkItem { [weak self] in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                DispatchQueue.main.async {
                    if reset {
                        self?.currentPage = 1
                    }
                    self?.currentPage = self?.currentKey == keyword ? self?.currentPage ?? 1 : 1
                    self?.isLastPage = self?.currentKey == keyword ? self?.isLastPage ?? true : false
                    if !(self?.isLastPage ?? true) {
                        self?.currentKey = keyword
                        self?.interactor?.searchGames(for: self?.currentKey ?? "", in: self?.currentPage ?? 1)
                    }
                }
            }
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
    }
    
    func reset() {
        searchGames(for: currentKey, reset: true)
    }
    
    func loadMore() {
        searchGames(for: currentKey)
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

extension SearchPresenter: InteractorToPresenterSearchProtocol {
    func searchSuccess(result: BaseModel<GameModel>) {
        if !result.next.isEmpty {
            currentPage += 1
        }
        isLastPage = result.next.isEmpty
        if self.isReset {
            view?.onSearchSuccessReset(data: result.result)
        } else {
            view?.onSearchSuccess(dat: result.result)
        }
    }
    
    func searchFailure(error: String) {
        view?.onSearchFailure(error: error)
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
