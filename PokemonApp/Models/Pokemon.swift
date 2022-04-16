//
//  Pokemon.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Foundation
import UIKit

struct PokemonList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Pokemon]?
}

struct Pokemon: Codable {
    var name: String
    var url: String
}

struct PokemonDetail: Codable {
    var name: String
    var species: Specie
    var abilities: [PokemonAbility]
    var id: Int
    var stats: [PokemonStat]
    var sprites: Spirites
}

struct PokemonAbility: Codable {
    var ability: Ability
    var is_hidden: Bool
    var slot: Int
}

struct Ability: Codable {
    var name: String
    var url: String
}

struct PokemonStat: Codable {
    var baseStat: Int
    var effort: Int
    var stat: Stat
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
      }
    
}

struct Stat: Codable {
    var name: String
    var url: String
}

struct Specie: Codable {
    var name: String
    var url: String
}

struct Spirites: Codable {
    var frontDefault: String
    var other: OtherSpirities
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}
    
struct OtherSpirities: Codable {
    var officialArtwork: SpiritOfficialArtwork
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct SpiritOfficialArtwork: Codable {
    var frontDefault: String
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonImage: Codable {
    public let image: Data
    public init(image: UIImage) {
        self.image = image.pngData()!
    }
}
