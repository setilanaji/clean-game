//
//  Endpoints.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//

import Foundation
import Alamofire

enum Endpoints {
    case getGamesIn(page: Int, request: GameRequest)
    case getGameDetailWith(id: Int)
    case searchFor(key: String, page: Int)
    case getGenres(page: Int)
    case getPlatforms(page: Int)
    case getParentPlatforms
    case getScreenshotsWith(id: Int)
    case getSellingStores(id: Int)
}

extension Endpoints: Endpoint {
    var base: String {
        guard let value = PlistUtil.getValueString(of: "Base Domain", from: .CleanGame) else {
            fatalError("Couldnt find file 'CleanGame-Info.plist' ")
        }
        return value
    }
    
    var apiKey: [String: Any] {
        guard let value = PlistUtil.getValueString(of: "Api Key", from: .CleanGame) else {
            return ["key": ""]
        }
        return ["key": value]
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .searchFor(let key, let page): return self.apiKey.merging(["search": key, "page": page]) {(current, _) in current}
        case .getGamesIn(let page, let request):
            return self.apiKey.merging([
                "search": request.search,
                "page": page,
                "ordering": request.ordering
            ]) {(current, _) in current}
        case .getPlatforms(let page):
            return self.apiKey.merging(["page": page]) {(current, _) in current}
        case .getGenres(let page):
            return self.apiKey.merging(["page": page]) {(current, _) in current}
        default: return self.apiKey
        }
    }
    
    var path: String {
        switch self {
        case .getGamesIn: return "games"
        case .getGameDetailWith(let id): return "games/\(id)"
        case .searchFor: return "games"
        case .getGenres: return "genres"
        case .getPlatforms: return "platforms"
        case .getParentPlatforms: return "platforms/lists/parents"
        case .getScreenshotsWith(let id): return "games/\(id)/screenshots"
        case .getSellingStores(let id): return "games/\(id)/stores"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default: return nil
        }
    }
    
    var url: URL {
        return URL(string: self.base + path)!
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default: return URLEncoding.default
        }
    }
    
    
}
