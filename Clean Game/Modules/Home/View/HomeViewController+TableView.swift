//
//  HomeViewController+TableView.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/28.
//

import UIKit

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.models[section] {
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch self.models[indexPath.section] {
        case .popularSection(let models, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: PopularSectionTableViewCell.identifier, for: indexPath) as! PopularSectionTableViewCell
            cell.configure(with: models)
            cell.layoutIfNeeded()
            cell.onTapGameItem = { id in
                self.presenter?.tapGame(with: id)
            }
            cell.shareHandler = { (name, slug) in
                self.shareGame(with: slug, name: name)
            }
            cell.onTapFavorite = { (game, isFavorite) in
                if isFavorite {
                    self.presenter?.addToFavorite(with: game)
                } else {
                    self.presenter?.removeFromFavorite(with: game)
                }
            }
            return cell
        case .newestSection(let models, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: NewestSectionTableViewCell.identifier, for: indexPath) as! NewestSectionTableViewCell
            cell.configure(with: models)
            cell.layoutIfNeeded()
            cell.onTapGameItem = { id in
                self.presenter?.tapGame(with: id)
            }
            cell.shareHandler = { (name, slug) in
                self.shareGame(with: slug, name: name)
            }
            cell.onTapFavorite = { (game, isFavorite) in
                if isFavorite {
                    self.presenter?.addToFavorite(with: game)
                } else {
                    self.presenter?.removeFromFavorite(with: game)
                }
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.models[indexPath.section] {
        case .popularSection(let models, _):
            return models.isEmpty ? 260 : UITableView.automaticDimension
        case .newestSection(let models, _):
            let availableHeight = (view.frame.width * 0.2) + 20
            return models.isEmpty ? (availableHeight * 6) : (availableHeight * CGFloat(models.count))
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

extension HomeViewController: UITableViewDelegate {
    
}
