//
//  NetworkDataFetcher.swift
//  JSONWebinar
//
//  Created by Александр on 30.10.2022.
//

import Foundation

final class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchTracks(urlString: String, response: @escaping (SearchResponse?) -> Void ) {
        networkService.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failure to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting error: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
