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
    case characteristics
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .header
        case 1: self = .stats
        case 2: self = .abilities
        case 3: self = .characteristics
        default: return nil
        }
    }
}

enum PokemonCharacteristics: Int, CaseIterable {
    case captureRate
    case generation
    case name
    case genderRate
}

class PokemonDetailViewController: UIViewController {
    
    var pokemonName: String?
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel = PokemonDetailVCViewModel()
    private var cancellables: Set<AnyCancellable> = []

    private let pokemonDetailCell = "pokemonDetailTableViewCell"
    private let statCell = "statsCell"
    private let abilityCell = "abilityCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pokemonDetailNib = UINib(nibName: "PokemonDetailTableViewCell", bundle: nil)
        tableView.register(pokemonDetailNib, forCellReuseIdentifier: "pokemonDetailTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: abilityCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: statCell)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.$pokemonImage.receive(on: DispatchQueue.main).sink { [weak self] image in
            if image != nil {
                self?.tableView.reloadSections([PokemonDetailSections.header.rawValue], with: .automatic)
            }
        }.store(in: &cancellables)
        viewModel.$pokemonDetail.receive(on: DispatchQueue.main).sink { [weak self] pokemonDetail in
            if let pokemonDetail = pokemonDetail {
                self?.title = pokemonDetail.name
                self?.tableView.reloadData()
            } else {
                self?.title = nil
            }
        }.store(in: &cancellables)
        viewModel.$pokemonSpecie.receive(on: DispatchQueue.main).sink { [weak self] specie in
            if let _ = specie {
                self?.tableView.reloadSections([PokemonDetailSections.characteristics.rawValue], with: .automatic)
            }
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pokemonName = pokemonName {
            viewModel.loadPokemonDetail(forName: pokemonName)
            viewModel.loadPokemonSpecie(forName: pokemonName)
        }
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
        case .characteristics:
            return viewModel.pokemonSpecie == nil ? 0 : PokemonCharacteristics.allCases.count
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch PokemonDetailSections(rawValue: indexPath.section) {
        case .header:
            let pokemonDetailCell = tableView.dequeueReusableCell(withIdentifier: pokemonDetailCell) as! PokemonDetailTableViewCell
            let pokemonDetail = viewModel.pokemonDetail
            pokemonDetailCell.nameUILabel.text = pokemonDetail?.name.capitalized
            //pokemonDetailCell.speciesUILabel.text = pokemonDetail?.species.name
            if let pokemonImage = viewModel.pokemonImage {
                pokemonDetailCell.imageUIImageView.image = pokemonImage
            } else {
                pokemonDetailCell.imageUIImageView.image = nil
            }
            return pokemonDetailCell
        case .stats:
            let statCell = UITableViewCell(style: .default, reuseIdentifier: statCell)
            var contentConfiguration = statCell.defaultContentConfiguration()
            let stat = viewModel.pokemonDetail?.stats[indexPath.row]
            contentConfiguration.text = stat?.stat.name.capitalized ?? ""
            contentConfiguration.secondaryText = "Base stat: \(String(stat?.baseStat ?? 0)), Effort: \(String(stat?.effort ?? 0))"
            statCell.contentConfiguration = contentConfiguration
            return statCell
        case .abilities:
            let abilitiyCell = UITableViewCell(style: .default, reuseIdentifier: abilityCell)
            var contentConfiguration = abilitiyCell.defaultContentConfiguration()
            let ability = viewModel.pokemonDetail?.abilities[indexPath.row]
            contentConfiguration.text = ability?.ability.name.capitalized ?? ""
            abilitiyCell.contentConfiguration = contentConfiguration
            return abilitiyCell
        case .characteristics:
            let row = indexPath.row
            // TODO: change reuseIdentifier for this cell
            let characteristicCell = UITableViewCell(style: .default, reuseIdentifier: abilityCell)
            var contentConfiguration = characteristicCell.defaultContentConfiguration()
            let pokemonSpecie = viewModel.pokemonSpecie
            switch PokemonCharacteristics(rawValue: row) {
            case .captureRate:
                // base capture rate; up to 255. The higher the number, the easier the catch
                let captureRate = pokemonSpecie?.captureRate ?? 0
                contentConfiguration.text = "Capture Rate"
                contentConfiguration.secondaryText = "\(String(captureRate)) of 255"
            case .generation:
                let generation = pokemonSpecie?.generation.name
                contentConfiguration.text = "Generation"
                let generationComponents = generation?.components(separatedBy: "-") ?? ["", ""]
                contentConfiguration.secondaryText = generationComponents[0].description.capitalized + "-" + generationComponents[1].uppercased()
            case .name:
                let name = pokemonSpecie?.name
                contentConfiguration.text = "Specie"
                contentConfiguration.secondaryText = name?.capitalized
            case .genderRate:
                //chance of this Pokémon being female, in eighths; or -1 for genderless. (multiply by 12.5 to get %)
                let genderRate = pokemonSpecie?.genderRate ?? 0
                contentConfiguration.text = "Gender Rate"
                let femalePercent: Double = (genderRate == -1) ? 0.0 : Double(genderRate) * 12.5
                let malePercent: Double = (genderRate == -1) ? 0.0 : Double(8 - genderRate) * 12.5
                contentConfiguration.secondaryText = "\(String(femalePercent))% female, \(String(malePercent))% male"
            case .none:
                break
            }
            characteristicCell.contentConfiguration = contentConfiguration
            return characteristicCell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch PokemonDetailSections(rawValue: section) {
        case .stats:
            if let _ = viewModel.pokemonDetail?.stats {
                return "Stats"
            } else {
                return nil
            }
        case .abilities:
            if let _ = viewModel.pokemonDetail?.abilities {
                return "Habilities"
            } else {
                return nil
            }
        case .characteristics:
                if let _ = viewModel.pokemonSpecie {
                    return "Characteristics"
                } else {
                    return nil
                }
        case .header, .none:
            return nil
        }
    }
    
    
}
