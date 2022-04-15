//
//  PokemonViewControllerViewModelTests.swift
//  PokemonAppTests
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import XCTest
@testable import PokemonApp

class PokemonListVCViewModelTests: XCTestCase {
    var mockPokemonServiceProtocol: PokemonServiceProtocol!
    var viewModel: PokemonListVCViewModel!
    
    override func setUp() {
        super.setUp()
        mockPokemonServiceProtocol = MockPokemonService()
        viewModel = PokemonListVCViewModel(service: mockPokemonServiceProtocol)
    }
    
    func testLoadPokemons() {
        XCTAssertEqual(viewModel.pokemonList?.results?.count, 20)
    }


}
