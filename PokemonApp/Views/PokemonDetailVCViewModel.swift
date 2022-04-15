//
//  PokemonDetailVCViewModel.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/15/22.
//

import Foundation
import Combine

final class PokemonDetailVCViewModel: ObservableObject {

    @Published var pokemonDetail: PokemonDetail?
    private let service: PokemonServiceProtocol
    var urlString: String = ""
    
    init(service: PokemonServiceProtocol = PokemonService()){
        self.service = service
    }
    
    func loadPokemonDetail() {
        service.fetchPokemonDetails(withURLString: urlString) { [weak self] result in
            switch result {
            case .success(let pokemonDetail):
                self?.pokemonDetail = pokemonDetail
            case .failure(let error):
                print("Error in loadPokemonDetail(). ", error.localizedDescription)
            }
        }
    }
}
