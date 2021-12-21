//
//  HomeRouter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import UIKit

class HomeRouter: PresenterToRouterHomeProtocol {
    
    func toDetail(with id: Int, on view: PresenterToViewHomeProtocol) {
        let detail = ModuleInjection.provideDetai(with: id)
        detail.hidesBottomBarWhenPushed = true
        let viewController = view as! HomeViewController
        viewController.navigationController?.pushViewController(detail, animated: true)
    }
    
    func toProfile(on view: PresenterToViewHomeProtocol) {
        let profile = ModuleInjection.provideAbout()
        let viewController = view as! HomeViewController
        viewController.present(profile, animated: true, completion: nil)
    }
}
