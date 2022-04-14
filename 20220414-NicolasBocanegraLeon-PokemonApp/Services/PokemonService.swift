//
//  PokemonService.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemons(afterOffset offset: Int)
    func fetchPokemonAbility(withID pokemonID: String?, orName name: String?)
}

final class PokemonService {
    
    // MARK: Service Properties
    private let baseURLString = "https://pokeapi.co/api/v2/"
    private let urlSession: URLSession
    
    // MARK: Routes
    enum Endpoint: String {
        case listAndPagination = "pokemon/"
        // Lists/Pagination
        // GET https://pokeapi.co/api/v2/pokemon/?limit=60&offset=60 | 'limit' and 'offset' are optional parameters. Default value = 20 per page.
        
        case abilities = "ability/"
        // Abilities
        // GET https://pokeapi.co/api/v2/ability/{id or name}/
    }
    
    // MARK: Initializer
    init(urlSession: URLSession = URLSession.shared) {
        // Uses singleton shared object on default initialization
        self.urlSession = urlSession
    }
}

extension PokemonService: PokemonServiceProtocol {
    // MARK: Methods
    func fetchPokemons(afterOffset offset: Int) {
        
    }
    
    func fetchPokemonAbility(withID pokemonID: String?, orName name: String?) {
        
    }
    
    
}