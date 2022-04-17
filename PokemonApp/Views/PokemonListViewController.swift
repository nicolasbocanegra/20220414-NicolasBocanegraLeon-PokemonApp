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
    @IBOutlet weak var footerUILabel: UILabel!
    let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = PokemonListVCViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var pokemonTotal = 0
    private var loadedPokemons: [Pokemon] = []
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
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // UITableView condiguration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: pokemonCell)
        
        viewModel.$pokemonList.receive(on: DispatchQueue.main).sink { [weak self] pokemonList in
            guard let pokemonList = pokemonList, let newPokemons = pokemonList.results else {
                return
            }
            print(newPokemons.first)
            if let loadedPokemons = self?.loadedPokemons, loadedPokemons.isEmpty {
                self?.pokemonTotal = pokemonList.count
                self?.loadedPokemons = newPokemons
                self?.tableView.reloadData()
            } else {
                var row = (self?.loadedPokemons.count ?? 1) - 1
                let section = PokemonListSections.pokemonList.rawValue
                var indexPaths: [IndexPath] = []
                for pokemon in newPokemons {
                    let indexPath = IndexPath(row: row + 1, section: section)
                    indexPaths.append(indexPath)
                    self?.loadedPokemons.append(pokemon)
                    row += 1
                }
                self?.tableView.performBatchUpdates({
                    self?.tableView.insertRows(at: indexPaths, with: .automatic)
                })
            }
            self?.footerUILabel.text = "Showing \(self?.loadedPokemons.count ?? 0) of \( self?.pokemonTotal ?? 0)"
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
                pokemonDetailVC.pokemonName = loadedPokemons[selectedPokemonindex.row].name
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
            return loadedPokemons.count
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
                pokemon = loadedPokemons[indexPath.row]
            }
            let pokemonCell = UITableViewCell(style: .default, reuseIdentifier: pokemonCell)
            var contentConfiguration = pokemonCell.defaultContentConfiguration()
            contentConfiguration.text = pokemon?.name.capitalized
            // TODO: Add image to pokemon cell
            // contentConfiguration.image = UIImage(named: "Sun")
            pokemonCell.contentConfiguration = contentConfiguration
            pokemonCell.accessoryType = .disclosureIndicator
            return pokemonCell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
            indexPathsForVisibleRows.contains([PokemonListSections.pokemonList.rawValue, loadedPokemons.count - 1]) {
            print("limit: ", 20, " offset: ", loadedPokemons.count)
            viewModel.loadPokemons(limit: 20, offset: loadedPokemons.count)
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
        filteredPokemons = loadedPokemons.filter({ (pokemon: Pokemon) -> Bool in
            return pokemon.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
}

