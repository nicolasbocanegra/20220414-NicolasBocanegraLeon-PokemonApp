//
//  PokemonViewControllerViewModel.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Combine
import Foundation

final class PokemonListVCViewModel: ObservableObject {
    
    @Published var pokemonList: PokemonList?
    private let service: PokemonServiceProtocol
    
    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
        loadPokemons()
    }
    
    private func loadPokemons() {
        service.fetchPokemonList(withPageSize: (limit: 20, offset: 0)) { [weak self] result in
            switch result {
            case .success(let pokemonList):
                self?.pokemonList = pokemonList
            case .failure(let error):
                print("Error in loadPokemons(). ", error.localizedDescription)
            }
        }
    }
}
