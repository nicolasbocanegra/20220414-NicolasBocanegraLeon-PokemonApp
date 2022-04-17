//
//  PokemonService.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Foundation
import UIKit

protocol PokemonServiceProtocol {
    func fetchPokemonList(withPageSize pageSize: (limit: Int?, offset: Int?), completion: @escaping (Result<PokemonList, Error>) -> Void)
    func fetchPokemonDetails(forName name: String, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
    func fetchPokemonSpecies(forName name: String, completion: @escaping (Result<PokemonSpecie, Error>) -> Void)
    func fetchPokemonAbility(forName name: String, completion: @escaping (Result<Ability, Error>) -> Void)
    func fetchPokemonImage(withURLString urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

final class PokemonService {
    

    private let urlSession: URLSession
    
    enum Router {
        static let baseUrlString = "https://pokeapi.co/api/v2/"
        
        // Lists/Pagination
        // GET https://pokeapi.co/api/v2/pokemon/?limit=60&offset=60 | 'limit' and 'offset' are optional parameters. Default value = 20 per page.
        case listAndPagination(pageSize: (limit: Int?, offset: Int?))
        
        // Pokemon (endpoint)
        // GET https://pokeapi.co/api/v2/pokemon/{id or name}/
        case pokemon(name: String)
        
        // Pokemon Species
        // GET https://pokeapi.co/api/v2/pokemon-species/{id or name}/
        case species(name: String)
        
        // Abilities
        // GET https://pokeapi.co/api/v2/ability/{id or name}/
        case abilities(name: String)
        
        var urlString: String {
            get {
                switch self {
                case .listAndPagination(pageSize: let pageSize):
                    var pokemonURLString = Router.baseUrlString + "pokemon/"
                    if let limit = pageSize.limit {
                        pokemonURLString += "?limit=\(limit)"
                        if let offset = pageSize.offset {
                            pokemonURLString += "&offset=\(offset)"
                        }
                        return pokemonURLString
                    } else {
                        return pokemonURLString
                    }
                case .pokemon(name: let name):
                    return Router.baseUrlString + "pokemon/\(name)/"
                case .species(name: let name):
                    return Router.baseUrlString + "pokemon-species/\(name)/"
                case .abilities(name: let name):
                    return Router.baseUrlString + "ability/\(name)/"
                }
            }
        }
    }
    
    // MARK: Initializer
    init(urlSession: URLSession = URLSession.shared) {
        // Uses singleton shared object on default initialization
        self.urlSession = urlSession
    }
}

extension PokemonService: PokemonServiceProtocol {
    func fetchPokemonList(withPageSize pageSize: (limit: Int?, offset: Int?), completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let urlString = Router.listAndPagination(pageSize: pageSize).urlString
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
    
    func fetchPokemonDetails(forName name: String, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        let urlString = Router.pokemon(name: name).urlString
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
    
    func fetchPokemonSpecies(forName name: String, completion: @escaping (Result<PokemonSpecie, Error>) -> Void) {
        let urlString = Router.species(name: name).urlString
        guard let url = URL(string: urlString) else {
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let pokemonSpecie = try JSONDecoder().decode(PokemonSpecie.self, from: data!)
                completion(.success(pokemonSpecie))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonAbility(forName name: String, completion: @escaping (Result<Ability, Error>) -> Void) {
        
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
