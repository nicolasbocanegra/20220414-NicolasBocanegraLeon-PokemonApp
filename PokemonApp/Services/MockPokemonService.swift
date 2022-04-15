//
//  MockPokemonService.swift
//  20220414-NicolasBocanegraLeon-PokemonAppTests
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import Foundation
@testable import PokemonApp

final class MockPokemonService: PokemonServiceProtocol {
    func fetchPokemons(completion: @escaping (Result<PokemonList, Error>) -> Void) {
        // Using ./Fixtures/pokemons.json file
        let filePath = Bundle(for: type(of: self)).path(forResource: "pokemons", ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
        let jsonData = try! Data(contentsOf: fileURL)
        let pokemonList = try! JSONDecoder().decode(PokemonList.self, from: jsonData)
        completion(.success(pokemonList))
    }
}
