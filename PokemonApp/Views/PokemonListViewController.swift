//
//  PokemonListViewController.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import UIKit
import Combine

class PokemonListViewController: UIViewController {
    enum PokemonListSections: Int, CaseIterable {
        case pokemonList
    }
    
    @IBOutlet private weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = PokemonListVCViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var filteredPokemons: [Pokemon]?
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // TableViewCell Identifiers
    private var pokemonCell = "pokemonCell"
    private var selectedPokemonindex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UISearchBar configuration
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pokemon name"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        // UITableView condiguration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: pokemonCell)
        
        // View model setuo
        viewModel.objectWillChange.receive(on: RunLoop.main).sink { [weak self] value in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let selectedPokemonindex = selectedPokemonindex,
                    let pokemonDetailVC = segue.destination as? PokemonDetailViewController else {
                return
            }
            pokemonDetailVC.modalPresentationStyle = .currentContext
            if isFiltering {
                pokemonDetailVC.pokemonName = filteredPokemons?[selectedPokemonindex.row].name
            } else {
                pokemonDetailVC.pokemonName = viewModel.pokemonList?.results?[selectedPokemonindex.row].name
            }
        }
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PokemonListSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch PokemonListSections(rawValue: section) {
        case .pokemonList:
            if isFiltering {
                return filteredPokemons?.count ?? 0
            }
            return viewModel.pokemonList?.results?.count ?? 0
        case .none:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch PokemonListSections(rawValue: indexPath.section) {
        case .pokemonList:
            let pokemon: Pokemon?
            if isFiltering {
                pokemon = filteredPokemons?[indexPath.row]
            } else {
                pokemon = viewModel.pokemonList?.results?[indexPath.row]
            }
            let pokemonCell = UITableViewCell(style: .default, reuseIdentifier: pokemonCell)
            var contentConfiguration = pokemonCell.defaultContentConfiguration()
            contentConfiguration.text = pokemon?.name.capitalized
            // contentConfiguration.secondaryText = pokemon?.url
            pokemonCell.contentConfiguration = contentConfiguration
            return pokemonCell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemonindex = indexPath
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchText = searchBar.text else { return }
        filterPokemons(forSearchText: searchText)
    }
    
    func filterPokemons(forSearchText searchText: String) {
        filteredPokemons = viewModel.pokemonList?.results?.filter({ (pokemon: Pokemon) -> Bool in
            return pokemon.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
}

