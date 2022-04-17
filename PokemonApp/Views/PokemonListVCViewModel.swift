//
//  PokemonViewControllerViewModel.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Combine
import Foundation
import UIKit

final class PokemonListVCViewModel: ObservableObject {
    
    @Published var pokemonList: PokemonList?
    @Published var pokemonSmallImage: (id: Int, image: UIImage)?
    private let service: PokemonServiceProtocol
    private var isFechInProgress = false
    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
        loadPokemons()
    }
    
    func loadPokemons(limit: Int = 20, offset: Int = 0) {
        if isFechInProgress { return }
        isFechInProgress = true
        service.fetchPokemonList(withPageSize: (limit: 20, offset: offset)) { [weak self] result in
            self?.isFechInProgress = false
            switch result {
            case .success(let pokemonList):
                var resultsWithID: [Pokemon] = []
                if let pokemons = pokemonList.results {
                    let basePokemonURL = "https://pokeapi.co/api/v2/pokemon/"
                    for pokemon in pokemons {
                        if let pokemonID = Int(pokemon.url.replacingOccurrences(of: basePokemonURL, with: "").replacingOccurrences(of: "/", with: "")) {
                            var pokemon = pokemon
                            self?.loadSmallPokemonImage(withPokemonID: pokemonID)
                            pokemon.id = pokemonID
                            resultsWithID.append(pokemon)
                        }
                    }
                }
                var pokemonList = pokemonList
                pokemonList.results = resultsWithID
                self?.pokemonList = pokemonList
            case .failure(let error):
                print("Error in loadPokemons(). ", error.localizedDescription)
            }
        }
    }
    
    func loadSmallPokemonImage(withPokemonID pokemonID: Int) {
        service.fetchSmallPokemonImage(withPokemonID: pokemonID) { [weak self] result in
            switch result {
            case .success(let image):
                if let image = image {
                    self?.pokemonSmallImage = (id: pokemonID, image: image)
                }
            case .failure(let error):
                print("Error in loadSmallPokemonImage(). ", error.localizedDescription)
            }
            
        }
        
    }
}
