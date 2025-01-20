//
//  Dependency.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation

protocol API {
    init()
}

class Dependency {
    static let shared = Dependency()
    
    private init() {}
    
    func api<T: API>(_ type: T.Type) -> T {
        return T()
    }
}
