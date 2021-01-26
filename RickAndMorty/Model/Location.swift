//
//  Location.swift
//  RickAndMorty
//
//  Created by сергей on 21.01.2021.
//

import Foundation

/**
 Location struct contains all functions to request location(s) information(s).
 */
struct Location {

    struct LocationInfoModel: Codable {
        let info: Info
        let results: [LocationModel]
    }
    
    struct LocationModel: Codable, Identifiable  {
        public let id: Int
        public let name: String
        public let type: String
        public let dimension: String
        public let residents: [String]
        public let url: String
        public let created: String
    }
}
