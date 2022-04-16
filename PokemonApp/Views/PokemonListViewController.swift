//
//  PokemonListViewController.swift
//  20220414-NicolasBocanegraLeon-PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import UIKit
import Combine

class PokemonListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel = PokemonListVCViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // TableViewCell Identifiers
    private var pokemonCell = "pokemonCell"
    private var selectedPokemonindex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: pokemonCell)
        viewModel.objectWillChange.receive(on: RunLoop.main).sink { [weak self] value in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let pokemonDetailVC = segue.destination as? PokemonDetailViewController
            guard let selectedPokemonindex = selectedPokemonindex else {
                return
            }
            pokemonDetailVC?.detailsUrlString = viewModel.pokemonList?.results?[selectedPokemonindex.row].url
        }
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonList?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = viewModel.pokemonList?.results?[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: pokemonCell)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = pokemon?.name
        // contentConfiguration.secondaryText = pokemon?.url
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemonindex = indexPath
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}

