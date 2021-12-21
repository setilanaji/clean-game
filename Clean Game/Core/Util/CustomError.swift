//
//  CustomError.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation


enum APIError: Error {
    case requestFailed(message: String)
    case jsonParsingFailure(message: String)
    case unknownError(message: String)
    case serverError(message: String)
    case notFound(message: String)
    case unauthorized(message: String)
    case sessionEnded(message: String)
    case inactiveToken(message: String)
    case forbidden(message: String)
    case requestTimeout(message: String)
    case badRequest(message: String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .unknownError: return "Unknown Error"
        case .serverError: return "Server Error"
        case .notFound: return "URL Not Found"
        case .unauthorized: return "Unauthorized Error"
        case .sessionEnded: return "Your Session is Ended"
        case .inactiveToken: return "Token is not active"
        case .forbidden: return "Action is Forbidden"
        case .requestTimeout: return "Request Timeout"
        case .badRequest: return "Bad Request"
        }
    }
}

enum DatabaseError: LocalizedError {

  case invalidInstance
  case requestFailed
  
  var errorDescription: String? {
    switch self {
    case .invalidInstance: return "Database can't instance."
    case .requestFailed: return "Your request failed."
    }
  }

}
