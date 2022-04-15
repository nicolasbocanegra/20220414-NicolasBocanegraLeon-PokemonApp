//
//  PokemonViewControllerViewModel.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Combine
import Foundation

final class PokemonViewControllerViewModel: ObservableObject {
    
    @Published var pokemons: [Pokemon]?
    private let service: PokemonServiceProtocol
    
    init(service: PokemonServiceProtocol = PokemonService()){
        self.service = service
        loadPokemons()
    }
    
    private func loadPokemons() {
        service.fetchPokemons { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.pokemons = pokemons
            case .failure(let error):
                print("Error in loadPokemons(). ", error.localizedDescription)
            }
        }
    }
}
