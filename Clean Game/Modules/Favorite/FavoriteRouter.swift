//
//  FavoriteRouter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import UIKit

class FavoriteRouter: PresenterToRouterFavoriteProtocol {
    
    func toDetail(with id: Int, on view: PresenterToViewFavoriteProtocol) {
        let detail = ModuleInjection.provideDetai(with: id)
        detail.hidesBottomBarWhenPushed = true
        let viewController = view as! FavoriteViewController
        viewController.navigationController?.pushViewController(detail, animated: true)
    }
}
