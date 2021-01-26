//
//  Episode.swift
//  RickAndMorty
//
//  Created by сергей on 21.01.2021.
//

import Foundation

struct EpisodeInfoModel: Codable {
    let info: Info
    let results: [EpisodeModel]
}


struct EpisodeModel: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
            case id, name
            case airDate = "air_date"
            case episode, characters, url, created
        }
}



struct Episode {
    
    let networkHandler: NetworkHandler = NetworkHandler()
    

    
}
