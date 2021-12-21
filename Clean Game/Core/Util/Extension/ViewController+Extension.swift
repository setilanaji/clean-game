//
//  ViewController+Extension.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/6.
//

import UIKit
import SwiftMessages

extension UIViewController {
    func shareGame(with slug: String, name: String) {
        let items: [Any] = ["Lihat \(name)", URL(string: "https://rawg.io/games/\(slug)")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    func showMessage(of type: Theme, title: String, subtitle: String) {
        let message = MessageView.viewFromNib(layout: .cardView)
        message.configureTheme(type)
        message.configureDropShadow()
        message.configureContent(title: title, body: subtitle)
        message.button?.isHidden = true
        var messageConfig = SwiftMessages.defaultConfig
        messageConfig.presentationStyle = .top
        messageConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: messageConfig, view: message)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
