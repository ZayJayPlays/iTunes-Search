//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Zane Jones on 4/26/23.
//

import Foundation

let baseURL = URL(string: "https://itunes.apple.com/search")!
var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
func buildURL() -> URL? {
    let query: [String: String] = [
        "term": "apple",
        "media": "movie"
    ]
    components.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
    return components.url!
}

let url = buildURL()!
let session = URLSession.shared
enum errorEnum: Error, LocalizedError {
    case itemNotFound
}
class StoreItemController {
    func fetchItem(matching query: [String: String]) async throws -> [StoreItem] {
        var urlComponents = components
        
        urlComponents.queryItems = query.map {  URLQueryItem(name: $0, value: $1) }
        
        let (data, response) = try await session.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw errorEnum.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        return searchResponse.results
    }
}
