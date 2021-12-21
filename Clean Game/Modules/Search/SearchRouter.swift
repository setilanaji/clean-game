//
//  SearchRouter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//  
//

import UIKit

class SearchRouter: PresenterToRouterSearchProtocol {
    func toDetail(with id: Int, on view: PresenterToViewSearchProtocol) {
        let detail = ModuleInjection.provideDetai(with: id)
        detail.hidesBottomBarWhenPushed = true
        let viewController = view as! SearchViewController
        viewController.navigationController?.pushViewController(detail, animated: true)
    }
}
