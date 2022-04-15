//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import UIKit
import Combine

enum PokemonDetailSections: Int, CaseIterable {
    case header
    case stats
    case abilities
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .header
        case 1: self = .stats
        case 2: self = .abilities
        default: return nil
        }
    }
}

class PokemonDetailViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let viewModel = PokemonDetailVCViewModel()
    var detailsUrlString: String? {
        didSet {
            viewModel.urlString = detailsUrlString ?? ""
        }
    }
    private var cancellables: Set<AnyCancellable> = []

    private let headerCell = "headerCell"
    private let statCell = "statsCell"
    private let abilityCell = "abilityCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: headerCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: abilityCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: statCell)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.objectWillChange.receive(on: RunLoop.main).sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPokemonDetail()
    }
}

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        PokemonDetailSections.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch PokemonDetailSections(rawValue: section) {
        case .header:
            return 1
        case .stats:
            return viewModel.pokemonDetail?.stats.count ?? 0
        case .abilities:
            return viewModel.pokemonDetail?.abilities.count ?? 0
        case .none:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch PokemonDetailSections(rawValue: indexPath.section) {
        case .header:
            let headerCell = UITableViewCell(style: .default, reuseIdentifier: headerCell)
            var contentConfiguration = headerCell.defaultContentConfiguration()
            let pokemonDetail = viewModel.pokemonDetail
            contentConfiguration.text = pokemonDetail?.name
            contentConfiguration.secondaryText = pokemonDetail?.species.name
            headerCell.contentConfiguration = contentConfiguration
            return headerCell
        case .stats:
            let statCell = UITableViewCell(style: .default, reuseIdentifier: statCell)
            var contentConfiguration = statCell.defaultContentConfiguration()
            let stat = viewModel.pokemonDetail?.stats[indexPath.row]
            contentConfiguration.text = stat?.stat.name ?? ""
            contentConfiguration.secondaryText = String(stat?.baseStat ?? 0)
            statCell.contentConfiguration = contentConfiguration
            return statCell
        case .abilities:
            let abilitiyCell = UITableViewCell(style: .default, reuseIdentifier: abilityCell)
            var contentConfiguration = abilitiyCell.defaultContentConfiguration()
            let ability = viewModel.pokemonDetail?.abilities[indexPath.row]
            contentConfiguration.text = ability?.ability.name ?? ""
            abilitiyCell.contentConfiguration = contentConfiguration
            return abilitiyCell
        case .none:
            return UITableViewCell()
        }
    }
    
    
}
