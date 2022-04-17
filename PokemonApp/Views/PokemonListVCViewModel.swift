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
                self?.pokemonList = pokemonList
            case .failure(let error):
                print("Error in loadPokemons(). ", error.localizedDescription)
            }
        }
    }
}
