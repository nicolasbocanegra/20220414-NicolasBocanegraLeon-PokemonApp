//
//  Pokemon.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Foundation

struct Pokemon: Codable {
    var id: Int
    var name: String
    var imageUrl: String?
    var stats: [PokemonStat]?
    var abilities: [PokemonAbility]?
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
