//
//  Pokemon.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Foundation

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
    var baseStat: String
    var effort: Int
    var stat: Stat
    var spirites: Spirites
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
}
    
struct OtherSpirities: Codable {
    var officialArtwork: String
}

struct SpiritOfficialArtwork: Codable {
    var frontDefault: String
}
