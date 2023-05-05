//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Zane Jones on 4/26/23.
//

import Foundation
struct StoreItem: Codable{
    var name: String
    var artist: String
    var kind: String
    var artwork: URL
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case artwork = "artworkUrl100"
        case description
    }
    
    enum AdditionalKeys: CodingKey {
        case longDescription
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artwork = try values.decode(URL.self, forKey:
           CodingKeys.artwork)
        if let description = try? values.decode(String.self,
           forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy:
               AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self,
               forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
}

struct SearchResponse: Codable {
    let results: [StoreItem]
}
