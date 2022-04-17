//
//  PokemonDetailTableViewCell.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/15/22.
//

import UIKit

class PokemonDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUIImageView: UIImageView!
    @IBOutlet weak var idUILabel: UILabel!
    @IBOutlet weak var nameUILabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
