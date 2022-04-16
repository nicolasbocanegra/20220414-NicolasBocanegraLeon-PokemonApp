//
//  PokemonService.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Foundation
import UIKit

protocol PokemonServiceProtocol {
    func fetchPokemons(completion: @escaping (Result<PokemonList, Error>) -> Void)
    func fetchPokemonDetails(withURLString urlString: String, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
    func fetchPokemonImage(withURLString urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
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
    
    func fetchPokemons(completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let urlString = baseURLString + Endpoint.listAndPagination.rawValue
        guard let url = URL(string: urlString) else {
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data!)
                completion(.success(pokemonList))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonDetails(withURLString urlString: String, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let pokemonDetails = try JSONDecoder().decode(PokemonDetail.self, from: data!)
                completion(.success(pokemonDetails))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonImage(withURLString urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            let pokemonImage = UIImage(data: data)
            completion(.success(pokemonImage))
        }.resume()
    }
}
