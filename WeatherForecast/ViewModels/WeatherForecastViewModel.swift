//
//  WeatherForecastPage.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation
import Combine

class WeatherForecastViewModel: ObservableObject {
    @Published var data: [TemperatureModel] = []
    @Published var markData: [TemperatureModel] = []
    @Published var address: String?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
    }
    
    func requestData() {
        self.isLoading = true
        locationManager.requestLocationPermission()
        locationManager.getCurrentLocation { [weak self] coordinate, error in
            guard let self = self else { return }
            if let coordinate = coordinate {
                
                self.locationManager.fetchAddress(location: coordinate).sink(receiveCompletion: { comletion in
                    switch comletion {
                    case .failure(let error):
                        self.address = error.localizedDescription
                    default:
                        break
                    }
                }, receiveValue: { address in
                    self.address = address
                }).store(in: &cancellables)
                
                Dependency.shared.api(WeatherForcastAPI.self).request(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
                    .sink { completion in
                        self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        default:
                            break
                        }
                    } receiveValue: { data in
                        print("Data Loaded: \(data.count)")
                        self.data = data
                        self.markData = data.filter { model in
                            model.isStartOrEndOfDay == true
                        }
                    }.store(in: &cancellables)
                
                
            } else if let error = error {
                self.errorMessage = "Error getting location: \(error.localizedDescription)"
            }
            
        }
    }
    
}
