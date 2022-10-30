//
//  SearchResponse.swift
//  JSONWebinar
//
//  Created by Александр on 29.10.2022.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Track]
    
}
struct Track: Decodable {
    let trackName: String?
    let collectionName: String?
    let artistName: String
    let artworkUrl60: String?
}
