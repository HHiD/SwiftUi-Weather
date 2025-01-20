//
//  NetworkHandler.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

struct NetworkingConfiguration {
    let autoretry: Bool
    let retryAttempts: Int
}


class NetworkingHandler {
    
    private var configuration: NetworkingConfiguration
        
    init(configuration: NetworkingConfiguration = NetworkingConfiguration(autoretry: false, retryAttempts: 1)) {
            self.configuration = configuration
        }
        
    func performRequest<T: Codable>(
          endpoint: Endpoints,
          method: HTTPMethod,
          type: [T].Type,
          endpointParameters: [String: String]? = nil,
          bodyParameters: [String: String]? = nil,
          decoder: (([String: Any]) -> [[String: Any]])? = nil,
          completion: @escaping (Result<[T], Error>) -> Void
      ) {
          let baseUrl = "https://api.open-meteo.com/"
          var urlString = "\(baseUrl)/\(endpoint.rawValue)"
          
          if let endpointParameters = endpointParameters, method == .GET {
              urlString += "?" + endpointParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
          }
          
          guard let url = URL(string: urlString) else {
              let error = NSError(domain: "InvalidURL", code: 400, userInfo: nil)
              completion(.failure(error))
              return
          }
          
          var request = URLRequest(url: url)
          request.httpMethod = method.rawValue
          
          if let bodyParameters = bodyParameters, method == .POST {
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
          }
          
          performRequestWithRetry(request: request, type: type, decoder: decoder, retryCount: configuration.retryAttempts, completion: completion)
      }
    private func performRequestWithRetry<T: Codable>(
            request: URLRequest,
            type: [T].Type,
            decoder: (([String: Any]) -> [[String: Any]])? = nil,
            retryCount: Int,
            completion: @escaping (Result<[T], Error>) -> Void
        ) {
            DispatchQueue.global(qos: .background).async {
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        if self.configuration.autoretry && retryCount > 0 {
                            print("Retrying... Attempts left: \(retryCount - 1)")
                            self.performRequestWithRetry(request: request, type: type, decoder: decoder, retryCount: retryCount - 1, completion: completion)
                        } else {
                            self.performOnMainThread {
                                completion(.failure(error))
                            }
                        }
                        return
                    }
                    
                    if let data = data {
                        print("Received Data: \(data)")
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                                print("Failed to decode Data to [String: Any]")
                                completion(.failure(MessageError.textError("Failed to decode Data to [String: Any]")))
                                return
                            }
                            
                            let decodedJson = decoder?(json) ?? [json]
                            
                            if let model = self.decodeBuilder(decodedJson, type: type) {
                                self.performOnMainThread {
                                    completion(.success(model))
                                }
                            } else {
                                self.performOnMainThread {
                                    print("Decode Failed")
                                    completion(.failure(MessageError.textError("Decode Failed")))
                                }
                            }
                        } catch {
                            print("Failed to decode Data to [String: Any]")
                            completion(.failure(MessageError.textError("Failed to decode Data to [String: Any]")))
                        }
                    }
                }
                task.resume()
            }
        }
    
    func performOnMainThread(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    func decodeBuilder<T: Codable>(_ json: [[String: Any]], type: [T].Type) -> [T]? {
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([T].self, from: jsonData)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
