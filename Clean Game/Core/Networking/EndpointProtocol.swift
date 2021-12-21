//
//  NetworkingProtocol.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//

import Foundation
import Alamofire

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var apiKey: [String: Any] { get }
    var parameters: [String: Any]? { get }
}
