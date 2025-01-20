//
//  CustomError.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation

enum MessageError: Error {
    case textError(String)
}

extension MessageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .textError(let message):
            return message
        }
    }
}
