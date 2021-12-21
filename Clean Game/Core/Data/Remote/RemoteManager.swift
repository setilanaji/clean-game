//
//  RemoteManager.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

protocol RemoteManagerProtocol {
    var session: Alamofire.Session { get }
    var requestQueue: DispatchQueue { get }
    var disposeBag: DisposeBag { get }
    
    func call<T>(type: Endpoint) -> Observable<T> where T: Codable
    
    func callBase<T>(type: Endpoint) -> Observable<BaseResponse<T>> where T: Codable
}

final class RemoteManager: RemoteManagerProtocol {
    var session: Session
    var requestQueue: DispatchQueue
    var disposeBag: DisposeBag
    
    init(
        session: Session,
        requestQueue: DispatchQueue = DispatchQueue(label: "com.ydhstj.cleangame.alamofireQueue"),
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.session = session
        self.requestQueue = requestQueue
        self.disposeBag = disposeBag
    }
    
    private static let remoteManager: RemoteManager = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForResource = 30
        configuration.timeoutIntervalForRequest = 60
        configuration.waitsForConnectivity = true
        
        let networkLogger = RemoteLogger()
        
        return RemoteManager(
            session: Session(
                configuration: configuration,
                delegate: SessionDelegate(),
                startRequestsImmediately: true,
                eventMonitors: [networkLogger]
            ))
    }()
    
    class func sharedInstance() -> RemoteManager {
        return remoteManager
    }
    
    func call<T>( type: Endpoint ) -> Observable<T> where T : Decodable, T : Encodable {
        return Observable<T>.create { observer in
            self.session.rx
                .request(type.httpMethod, type.url, parameters: type.parameters, encoding: type.encoding, headers: type.headers, interceptor: nil)
                .responseData()
                .expectingObject(ofType: T.self)
                .subscribe(onNext: { result in
                    observer.onNext(result)
                    observer.onCompleted()
                }, onError: { err in
                    observer.onError(err)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
       
    }
    
    func callBase<T>(type: Endpoint) -> Observable<BaseResponse<T>> where T : Decodable, T : Encodable {
        return Observable<BaseResponse<T>>.create { observer in
            self.session.rx
                .request(type.httpMethod, type.url, parameters: type.parameters, encoding: type.encoding, headers: type.headers, interceptor: nil)
                .responseData()
                .expectingObjectList(ofType: BaseResponse<T>.self)
                .subscribe(onNext: { apiResult in
                    observer.onNext(apiResult)
                    observer.onCompleted()
                }, onError: { err in
                    observer.onError(err)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

extension Observable where Element == (HTTPURLResponse, Data) {
    fileprivate func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<T>{
        return self.map{ (httpURLResponse, data) -> T in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                let object = try JSONDecoder().decode(type, from: data)
                return (object)
            case 400: throw APIError.inactiveToken(message: "")
            case 401: throw APIError.unauthorized(message: "")
            case 403: throw APIError.forbidden(message: "")
            case 404: throw APIError.notFound(message: "")
            default: throw APIError.unknownError(message: "")
            }
        }
    }
    
    fileprivate func expectingObjectList<T : Codable>(ofType type: BaseResponse<T>.Type) -> Observable<BaseResponse<T>>{
        return self.map{ (httpURLResponse, data) -> BaseResponse<T> in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                let object = try JSONDecoder().decode(type, from: data)
                return (object)
            case 400: throw APIError.inactiveToken(message: "")
            case 401: throw APIError.unauthorized(message: "")
            case 403: throw APIError.forbidden(message: "")
            case 404: throw APIError.notFound(message: "")
            default: throw APIError.unknownError(message: "")
            }
        }
    }
}
