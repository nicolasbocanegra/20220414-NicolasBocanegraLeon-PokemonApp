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
    @Published var pokemonSpecie: PokemonSpecie?
    @Published var pokemonImage: UIImage?
    
    private let service: PokemonServiceProtocol
    var urlString: String = ""
    
    init(service: PokemonServiceProtocol = PokemonService()){
        self.service = service
    }
    
    func loadPokemonDetail(forName name: String) {
        service.fetchPokemonDetails(forName: name) { [weak self] result in
            switch result {
            case .success(let pokemonDetail):
                self?.pokemonDetail = pokemonDetail
                // TODO: Remove this call from here and refacter loadPokemonImage() and service.
                self?.loadPokemonImage(withURLString: pokemonDetail.sprites.other.officialArtwork.frontDefault)
            case .failure(let error):
                print("Error in loadPokemonDetail(). ", error.localizedDescription)
            }
        }
    }
    
    func loadPokemonSpecie(forName name: String) {
        service.fetchPokemonSpecies(forName: name) { [weak self] result in
            switch result {
            case .success(let pokemonSpecie):
                self?.pokemonSpecie = pokemonSpecie
            case .failure(let error):
                print(error)
                print("Error in loadPokemonSpecie(). ", error.localizedDescription)
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
