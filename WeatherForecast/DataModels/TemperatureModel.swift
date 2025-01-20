//
//  TemperatureModel.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation

struct TemperatureModel: Identifiable, Codable, Equatable {
    let id: UUID = UUID()
    private let date: String
    private let temperature: String
    
    init(date: String, temperature: String) {
        self.date = date
        self.temperature = temperature
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        
        if let temperatureString = try? container.decode(String.self, forKey: .temperature) {
            self.temperature = temperatureString
        } else if let temperatureDouble = try? container.decode(Double.self, forKey: .temperature) {
            self.temperature = String(temperatureDouble)
        } else {
            self.temperature = "0.0"
        }
    }
    
    var formattedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return dateFormatter.date(from: self.date) ?? Date.distantPast
    }
        
    var formattedTemperature: Double {
        return Double(self.temperature) ?? 0.0
    }
    
    var itemDate: String {
        let currentDate = self.formattedDate
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            return dateFormatter.string(from: currentDate)
    }

    var itemTemperature: String {
        let tempString = String(format: "%.2f", self.formattedTemperature)
        return "\(tempString) °C"
    }

    
    var isStartOrEndOfDay: Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: self.formattedDate)
        
        return (components.hour == 0 && components.minute == 0 && components.second == 0) || (components.hour == 12 && components.minute == 0 && components.second == 0)
    }
    
    static func == (lhs: TemperatureModel, rhs: TemperatureModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.date == rhs.date &&
        lhs.temperature == rhs.temperature
    }

}
