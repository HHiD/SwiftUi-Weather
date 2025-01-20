//
//  WeatherForcastAPI.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation
import Combine

class WeatherForcastAPI: API {
    required init() {
        
    }
    
    func request(latitude: String, longitude: String) -> AnyPublisher<[TemperatureModel], Error> {
        return Future { promise in
            
            let timeZone = TimeZone.current
            let timeZoneIdentifier = timeZone.identifier.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "Asia%2FSingapore"
            let networkingHandler = NetworkingHandler(configuration: NetworkingConfiguration(autoretry: true, retryAttempts: 2))
            let endpointParam = [
                "latitude" : latitude,
                "longitude": longitude,
                "hourly": "temperature_2m",
                "timezone": timeZoneIdentifier
            ]
            
            networkingHandler.performRequest(endpoint: .get_forecast, method: .GET, type: [TemperatureModel].self, endpointParameters: endpointParam, decoder: { jsonMap in
                let dataSet = jsonMap["hourly"] as? [String: Any]
                if let timeArray = dataSet?["time"] as? [Any], let temperatureArray  = dataSet?["temperature_2m"] as? [Any]{
                
                    var combinedArray = [[String: Any]]()
                    for (index, date) in timeArray.enumerated() {
                        let temperature = temperatureArray[index]
                        let entry = ["date": date, "temperature": temperature]
                        combinedArray.append(entry)
                    }
                    return combinedArray
                }else {
                    return [jsonMap]
                }
                
                
            }) { result in
                switch result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
