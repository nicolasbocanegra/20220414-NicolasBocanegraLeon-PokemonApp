//
//  PokemonDetailVCViewModel.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/15/22.
//

import Foundation
import Combine
import UIKit

final class PokemonDetailVCViewModel: ObservableObject {

    @Published var pokemonDetail: PokemonDetail?
    @Published var pokemonImage: UIImage?
    
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
                self?.loadPokemonImage(withURLString: pokemonDetail.sprites.other.officialArtwork.frontDefault)
            case .failure(let error):
                print("Error in loadPokemonDetail(). ", error.localizedDescription)
            }
        }
    }
    
    func loadPokemonImage(withURLString urlString: String) {
        service.fetchPokemonImage(withURLString: urlString) { [weak self] result in
            switch result {
            case .success(let pokemonImage):
                self?.pokemonImage = pokemonImage
            case .failure(let error):
                print("Error in loadPokemonImage(wirhURLString: \(urlString). ", error.localizedDescription)
            }
        }
    }
}
