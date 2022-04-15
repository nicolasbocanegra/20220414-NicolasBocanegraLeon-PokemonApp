//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/14/22.
//

import UIKit

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
            return 2
        case .abilities:
            return 3
        case .none:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch PokemonDetailSections(rawValue: indexPath.section) {
        case .header:
            return cell
        case .stats:
            return cell
        case .abilities:
            return cell
        case .none:
            return cell
        }
    }
    
    
}
