//
//  Episode.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import Foundation

struct EpisodeResponse: Decodable {
    let info: Info
    let results: [Episode]
}

struct Episode: Decodable {
    let id: Int?
    let name: String?
    let airDate: String?
    let episode: String?
    let characters: [String]?
    let url: String?
    let created: String?
    
    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case name       = "name"
        case airDate    = "air_date"
        case episode    = "episode"
        case characters = "characters"
        case url        = "url"
        case created    = "created"
    }
    
    init(from decoder: Decoder) throws {
        let values      = try decoder.container(keyedBy: CodingKeys.self)
        id              = try values.decodeIfPresent(Int.self, forKey: .id)
        name            = try values.decodeIfPresent(String.self, forKey: .name)
        airDate         = try values.decodeIfPresent(String.self, forKey: .airDate)
        episode         = try values.decodeIfPresent(String.self, forKey: .episode)
        characters      = try values.decodeIfPresent([String].self, forKey: .characters)
        url             = try values.decodeIfPresent(String.self, forKey: .url)
        created         = try values.decodeIfPresent(String.self, forKey: .created)
    }
}
