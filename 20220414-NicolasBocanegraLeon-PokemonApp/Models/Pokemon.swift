//
//  Pokemon.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import UIKit

class Pokemon: Codable {
    var id: Int
    var name: String
    var url:
    image
    stats
    var abilities: [PokemonAbility]
}
struct PokemonAbility {
    var name: String
    var url: String
    var isHidden: Bool
    var slot: Int
}
