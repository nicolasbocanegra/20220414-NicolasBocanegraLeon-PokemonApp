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
    case details
    case specie
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .header
        case 1: self = .stats
        case 2: self = .abilities
        case 3: self = .details
        case 4: self = .specie
        default: return nil
        }
    }
}

enum PokemonDetails: Int, CaseIterable {
    case name, weight, height, types, baseExperience
}

enum PokemonCharacteristics: Int, CaseIterable {
    case captureRate
    case generation
    case genderRate
    case baseHappiness
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
        let pokemonDetaiCelllNib = UINib(nibName: "PokemonDetailTableViewCell", bundle: nil)
        tableView.register(pokemonDetaiCelllNib, forCellReuseIdentifier: "pokemonDetailTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: abilityCell)
        let pokemonStatCellNib = UINib(nibName: "StatTableViewCell", bundle: nil)
        tableView.register(pokemonStatCellNib.self, forCellReuseIdentifier: statCell)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.$pokemonImage.receive(on: DispatchQueue.main).sink { [weak self] image in
            if image != nil {
                self?.tableView.reloadSections([PokemonDetailSections.header.rawValue], with: .automatic)
            }
        }.store(in: &cancellables)
        viewModel.$pokemonDetail.receive(on: DispatchQueue.main).sink { [weak self] pokemonDetail in
            if let pokemonDetail = pokemonDetail {
                self?.title = pokemonDetail.name.capitalized
                self?.tableView.reloadData()
            } else {
                self?.title = nil
            }
        }.store(in: &cancellables)
        viewModel.$pokemonSpecie.receive(on: DispatchQueue.main).sink { [weak self] specie in
            if let _ = specie {
                self?.tableView.reloadSections([PokemonDetailSections.specie.rawValue], with: .automatic)
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
        case .details:
            return viewModel.pokemonDetail == nil ? 0 : PokemonDetails.allCases.count
        case .specie:
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
            if let pokemonID = pokemonDetail?.id {
                pokemonDetailCell.idUILabel.text = "#\(String(pokemonID))"
            }
            
            if let pokemonImage = viewModel.pokemonImage {
                pokemonDetailCell.imageUIImageView.image = pokemonImage
            } else {
                pokemonDetailCell.imageUIImageView.image = nil
            }
            return pokemonDetailCell
        case .stats:
            guard let statCell = tableView.dequeueReusableCell(withIdentifier: statCell) as? StatTableViewCell else {
                return UITableViewCell()
            }
            let stat = viewModel.pokemonDetail?.stats[indexPath.row]
            if let statName = stat?.stat.name, let baseStat = stat?.baseStat {
                statCell.configure(with: statName, baseStat: baseStat)
            }
            return statCell
        case .abilities:
            let abilitiyCell = UITableViewCell(style: .default, reuseIdentifier: abilityCell)
            var contentConfiguration = abilitiyCell.defaultContentConfiguration()
            let ability = viewModel.pokemonDetail?.abilities[indexPath.row]
            contentConfiguration.text = ability?.ability.name.capitalized ?? ""
            abilitiyCell.contentConfiguration = contentConfiguration
            return abilitiyCell
        case .details:
            let row = indexPath.row
            // TODO: change reuseIdentifier for this cell
            let detailCell = UITableViewCell(style: .value2, reuseIdentifier: abilityCell)
            var contentConfiguration = detailCell.defaultContentConfiguration()
            let pokemonDetail = viewModel.pokemonDetail
            switch PokemonDetails(rawValue: row)! {
            case .name:
                if let name = pokemonDetail?.name {
                    contentConfiguration.text = "Name"
                    contentConfiguration.secondaryText = name.capitalized
                }
            case .weight:
                if let weight = pokemonDetail?.weight {
                    let kilograms = String(format: "%0.2f", Double(weight) * 0.1).replacingOccurrences(of: ".", with: ",") + " kg"
                    let pounds = String(format: "%0.2f", Double(weight) / 4.536).replacingOccurrences(of: ".", with: ",") + " lbs."
                    contentConfiguration.text = "Weight"
                    contentConfiguration.secondaryText = pounds + " (" + kilograms + ")"
                }
            case .height:
                if let height = pokemonDetail?.height {
                    let meters = String(format: "%0.2f", Double(height) * 0.1).replacingOccurrences(of: ".", with: ",") + " m"
                    let footInch = String(format: "%0.2f", Double(height) / 3.048).replacingOccurrences(of: ".", with: ",") + " ft."
                    contentConfiguration.text = "Height"
                    contentConfiguration.secondaryText = footInch + " (" + meters + ")"
                }
            case .types:
                var stringTypes = ""
                let types = pokemonDetail?.types ?? []
                for (i, type) in types.enumerated() {
                    stringTypes += type.type.name.capitalized + " (slot \(type.slot))"
                    if i < types.count - 1 {
                        stringTypes += ", "
                    }
                }
                contentConfiguration.text = "Type"
                contentConfiguration.secondaryText = stringTypes
            case .baseExperience:
                if let baseExperienceYield = pokemonDetail?.baseExperience {
                    contentConfiguration.text = "Base experience yield"
                    contentConfiguration.secondaryText = String(baseExperienceYield)
                }
                
            }
            detailCell.contentConfiguration = contentConfiguration
            return detailCell
        case .specie:
            let row = indexPath.row
            // TODO: change reuseIdentifier for this cell
            let characteristicCell = UITableViewCell(style: .value2, reuseIdentifier: abilityCell)
            var contentConfiguration = characteristicCell.defaultContentConfiguration()
            let pokemonSpecie = viewModel.pokemonSpecie
            switch PokemonCharacteristics(rawValue: row)! {
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
            case .genderRate:
                //chance of this Pokémon being female, in eighths; or -1 for genderless. (multiply by 12.5 to get %)
                let genderRate = pokemonSpecie?.genderRate ?? 0
                contentConfiguration.text = "Gender Rate"
                if genderRate == -1 {
                    contentConfiguration.secondaryText = "Genderless"
                } else {
                    let femalePercent = Double(genderRate) * 12.5
                    let malePercent = Double(8 - genderRate) * 12.5
                    contentConfiguration.secondaryText = "\(String(femalePercent))% female, \(String(malePercent))% male"
                }
            case .baseHappiness:
                // base capture rate; up to 255. The higher the number, the easier the catch
                let baseHappiness = pokemonSpecie?.baseHappiness ?? 0
                contentConfiguration.text = "Base Happiness"
                contentConfiguration.secondaryText = "\(String(baseHappiness)) of 255"
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
            }
        case .abilities:
            if let _ = viewModel.pokemonDetail?.abilities {
                return "Habilities"
            }
        case .details:
            if let _ = viewModel.pokemonDetail {
                return "Details"
            }
        case .specie:
            if let _ = viewModel.pokemonSpecie {
                return "Specie"
            }
        case .header, .none:
            return nil
        }
        return nil
    }
    
}
