//
//  AppBackgroundTask.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation
import BackgroundTasks

class AppBackgroundTask {
    static let shared = AppBackgroundTask()
    
    static let identifier = "com.myapp.background.refresher"
    private init() {
    }
        
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: AppBackgroundTask.identifier)
        request.earliestBeginDate = .now.addingTimeInterval(30)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("=====Background Task Scheduled =====")
        } catch let error {
            print("=====Background Task Error: \(error)=====")
        }
    }

    func handleBackgroundTask(_ task: BGTask) {
        print("Background refresh handle")
        print("=====Background refresh handle=====")
           task.setTaskCompleted(success: true)
       }
}
