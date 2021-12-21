//
//  DetailGameInteractor.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation
import RxSwift
import CloudKit

class DetailGameInteractor: PresenterToInteractorDetailGameProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterDetailGameProtocol?
    var id: Int?
    
    private let repository: GameRepositoryProtocol
    private var disposeBag = DisposeBag()
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGameDetail() {
        guard let id = id else {
            return
        }
        repository.getGameDetail(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.getGameSuccess(result: result)
                self.getGameStores(with: id)
            } onError: { error in
                self.presenter?.getGameFailure(error: error as! APIError)
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
    
    func getGameScreeenshots() {
        guard let id = id else {
            return
        }
        repository.getGameScreenshots(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.getGameScreenshotsSuccess(result: result)
            } onError: { error in
                self.presenter?.getGamgeScreenshotsFailure(error: error as! APIError)
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
    
    func getGameStores(with id: Int) {
        repository.getSellingStores(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.getSellingStoresSuccess(result: result)
            } onError: { error in
                self.presenter?.getSellingStoresFailure(error: error.localizedDescription)
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
    
    func addToFavorite(with game: GameModel) {
        repository.addFavoriteGame(with: game)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.addToFavoriteSuccess(result: result)
            } onError: { error in
                self.presenter?.addToFavoriteFailure(error: error as? APIError ?? APIError.requestFailed(message: ""))
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
    
    func removeFromFavorite(with game: GameModel) {
        repository.removeFavoriteGame(with: game)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.removeFromFavoriteSuccess(result: result)
            } onError: { error in
                self.presenter?.removeFromFavoriteFailure(error: error as? APIError ?? APIError.requestFailed(message: ""))
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
}
