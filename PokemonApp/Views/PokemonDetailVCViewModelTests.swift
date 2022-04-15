//
//  PokemonDetailVCViewModelTEsts.swift
//  PokemonAppTests
//
//  Created by Nicolás Bocanegra León on 4/15/22.
//

import XCTest
@testable import PokemonApp

class PokemonDetailVCViewModelTests: XCTestCase {
    var mockPokemonServiceProtocol: PokemonServiceProtocol!
    var viewModel: PokemonDetailVCViewModel!
    
    override func setUp() {
        super.setUp()
        mockPokemonServiceProtocol = MockPokemonService()
        viewModel = PokemonDetailVCViewModel(service: mockPokemonServiceProtocol)
    }
    
    func testLoadPokemonDetail() {
        viewModel.loadPokemonDetail()
        XCTAssertEqual(viewModel.pokemonDetail?.id, 25)
    }


}
