//
//  NetworkService.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//

import Alamofire
import UIKit

final class NetworkService {
    private var parameters: Parameters = [:]
    private var host: String = ""

    func setupRequest(query: String) {
        if query.isEmpty {
            host = "https://api.unsplash.com/photos/"
            parameters = [
                "client_id": Token.accessKey.rawValue,
                "per_page": 20
            ]
        } else {
            host = "https://api.unsplash.com/search/photos"  
            parameters = [
                "client_id": Token.accessKey.rawValue,
                "query": query,
                "per_page": 20
            ]
        }
    }

    func getRequest(completion: @escaping (Result<[InfoModel], Error>) -> Void) {
        AF.request(host, method: .get, parameters: parameters).response { response in
            guard response.error == nil else {
                completion(.failure(response.error!))
                return
            }

            guard let jsonData = response.data else {
                completion(.failure(SystemError.unexpectedNilValue))
                return
            }

            do {
                if self.host.contains("search") {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                    completion(.success(searchResult.results))
                } else {
                    let data = try JSONDecoder().decode([InfoModel].self, from: jsonData)
                    completion(.success(data))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

struct SearchResult: Codable {
    let results: [InfoModel]
}

enum SystemError: Error {
    case unexpectedNilValue
}

enum Token: String {
    case accessKey = "_hE74YcvpS6bMxUpFdphq80vVKUb06AaFChunB3Se_Y"
}
