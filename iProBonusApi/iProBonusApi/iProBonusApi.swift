//
//  iProBonusApi.swift
//  iProBonusApi
//
//  Created by Nataly on 30.06.2023.
//

import Foundation

public class IProBonusAPI {
    private let accessKey: String
    private let clientID: String
    private let deviceID: String
    private let urlSession: URLSession
    
    public init(accessKey: String, clientID: String, deviceID: String, urlSession: URLSession = URLSession.shared) {
        self.accessKey = accessKey
        self.clientID = clientID
        self.deviceID = deviceID
        self.urlSession = urlSession
    }
    
    public func getBonusInfo(completion: @escaping (Result<BonusInfoResponseData, Error>) -> Void) {
        getAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.getBonusDetails(accessToken: accessToken, completion: completion)
            case .failure:
                return
            }
        }
    }
    
    private func getAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://84.201.188.117:5021/api/v3/clients/accesstoken") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        request.addValue(accessKey, forHTTPHeaderField: "AccessKey")
        
        let parameters = [
            "idClient": clientID,
            "paramName": "device",
            "paramValue": deviceID
        ]
        
        guard let jsonData = try? JSONEncoder().encode(parameters) else {
            print("Error creating JSON data")
            return
        }
        
        request.httpBody = jsonData
        
        urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No response data")
                return
            }
            
            guard let responseData = try? JSONDecoder().decode(Access.self, from: data) else {
                print("Error decoding JSON")
                return
            }
            
            completion(.success(responseData.accessToken))
        }.resume()
    }
    
    private func getBonusDetails(accessToken: String, completion: @escaping (Result<BonusInfoResponseData, Error>) -> Void) {
        guard let url = URL(string: "http://84.201.188.117:5003/api/v3/ibonus/generalinfo/\(accessToken)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(accessKey, forHTTPHeaderField: "AccessKey")
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No response data")
                return
            }
            
            guard let responseData = try? JSONDecoder().decode(BonusInfo.self, from: data) else {
                print("Error decoding JSON")
                return
            }
            
            completion(.success(responseData.data))
        }.resume()
    }
}
