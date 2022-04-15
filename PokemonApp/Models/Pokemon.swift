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

struct PokemonAbility: Codable {
    var name: String
    var url: String
    var isHidden: Bool
    var slot: Int
}

struct PokemonStat: Codable {
    var stat: String
    var effort: Int
    var base_stat: Int
}
