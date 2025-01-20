//
//  WeatherForecastApp.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import SwiftUI
import BackgroundTasks

@main
struct WeatherForecastApp: App {
    @Environment(\.scenePhase) private var phase
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            WeatherForecastView()
        }.onChange(of: phase) { oldPhase, newPhase in
            switch newPhase {
            case .background: AppBackgroundTask.shared.scheduleAppRefresh()
            default: break
            }
        }
        .backgroundTask(.appRefresh(AppBackgroundTask.identifier)) {
            print("[backgroundTask]", "\(AppBackgroundTask.identifier)", "invoked")
            //Not completly finished yet, I think with background refresh might need a data catch system, too much to do.
        }
        
    }
}


