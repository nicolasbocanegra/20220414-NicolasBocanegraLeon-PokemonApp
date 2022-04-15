//
//  PokemonViewControllerViewModelTests.swift
//  PokemonAppTests
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import XCTest
@testable import PokemonApp

class PokemonViewControllerViewModelTests: XCTestCase {
    var mockPokemonServiceProtocol: PokemonServiceProtocol!
    var viewModel: PokemonViewControllerViewModel!
    
    override func setUp() {
        super.setUp()
        mockPokemonServiceProtocol = MockPokemonService()
        viewModel = PokemonViewControllerViewModel(service: mockPokemonServiceProtocol)
    }
    
    func testLoadPokemons() {
        XCTAssertEqual(viewModel.pokemonList?.results?.count, 20)
    }


}
