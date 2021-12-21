//
//  RemoteLogger.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation
import Alamofire

class RemoteLogger: EventMonitor {
    let queue = DispatchQueue(label: "id.ydhstj.cleangame.networklogger")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return }
        #if DEBUG
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        } else {
            print("Can't parse json")
        }
        #endif
    }
}
