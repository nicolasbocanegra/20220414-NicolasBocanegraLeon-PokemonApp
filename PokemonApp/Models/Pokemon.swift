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
    var next, previous: String?
    var results: [Pokemon]?
}

struct Pokemon: Codable {
    var name: String
}

struct PokemonDetail: Codable {
    var id: Int
    var name: String
    var weight: Int // in hectograms
    var height: Int // in decimetres
    var baseExperience: Int
    //var species: Specie // needs to be fetched from https://pokeapi.co/api/v2/pokemon-species/{id or name}/
    var abilities: [PokemonAbility]
    var stats: [PokemonStat]
    var sprites: Spirites
    var types: [PokemonType]
    enum CodingKeys: String, CodingKey {
        case id, name, weight, height, abilities, stats, sprites, types
        case baseExperience = "base_experience"
    }
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
        case effort, stat
      }
}

struct Stat: Codable {
    var name: String
}

struct PokemonSpecie: Codable {
    var id: Int, captureRate: Int
    var generation: PokemonGeneration
    var name: String
    var genderRate: Int //chance of this Pokémon being female, in eighths; or -1 for genderless. (multiply by 12.5 to get %)
    enum CodingKeys: String, CodingKey {
        case captureRate = "capture_rate"
        case genderRate = "gender_rate"
        case id, generation, name
    }
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

struct PokemonType: Codable {
    var slot: Int
    var type: TypeDetail
}

struct PokemonGeneration: Codable {
    var name: String
}

struct TypeDetail: Codable {
    var name: String
}
