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
    private let viewModel = PokemonViewControllerViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // TableViewCell Identifiers
    private var pokemonCell = "pokemonCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokemon"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: pokemonCell)
        viewModel.objectWillChange.receive(on: RunLoop.main).sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancellables)

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
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
}

