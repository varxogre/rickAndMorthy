//
//  Character.swift
//  RickAndMorty
//
//  Created by сергей on 21.01.2021.
//

import Foundation

struct CharacterInfoModel: Codable {
    let info: Info
    let results: [CharacterModel]
}


struct CharacterModel: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let origin: CharacterOriginModel
    public let location: CharacterLocationModel
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}


struct CharacterOriginModel: Codable {
    public let name: String
    public let url: String
}

struct CharacterLocationModel: Codable {
    public let name: String
    public let url: String
}

enum Status: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    case none = ""
}

enum Gender: String {
    case female = "female"
    case male = "male"
    case genderless = "genderless"
    case unknown = "unknown"
    case none = ""
}


struct Character {
    
    let networkHandler: NetworkHandler = NetworkHandler()
    
    
    func getInfo(completion: @escaping (Result<CharacterInfoModel, Error>) -> Void) {
        networkHandler.performAPIRequestByURL(url: Constants.charactersUrl, completion: {
            switch $0 {
            case .success(let data):
                if let info: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                    completion(.success(info))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /**
     Request character by id.
     - Parameters:
     - id: ID of the character.
     - Returns: Character model struct.
     */
    func getCharacterByID(id: Int, completion: @escaping (Result<CharacterModel, Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "character/" + String(id)) {
            switch $0 {
            case .success(let data):
                if let character: CharacterModel = self.networkHandler.decodeJSONData(data: data) {
                    completion(.success(character))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Request character by URL.
     - Parameters:
     - url: URL of the character.
     - Returns: Character model struct.
     */
    func getCharacterByURL(url: String, completion: @escaping (Result<CharacterModel, Error>) -> Void) {
        networkHandler.performAPIRequestByURL(url: url) {
            switch $0 {
            case .success(let data):
                if let character: CharacterModel = self.networkHandler.decodeJSONData(data: data) {
                    completion(.success(character))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCharactersByID(ids: [Int], completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        let stringIDs = ids.map { String($0) }
        networkHandler.performAPIRequestByMethod(method: "character/" + stringIDs.joined(separator: ",")) {
            switch $0 {
            case .success(let data):
                if let characters: [CharacterModel] = self.networkHandler.decodeJSONData(data: data) {
                    completion(.success(characters))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCharactersByPageNumber(pageNumber: Int, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "character/" + "?page=" + String(pageNumber)) {
            switch $0 {
            case .success(let data):
                if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                    completion(.success(infoModel.results))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
