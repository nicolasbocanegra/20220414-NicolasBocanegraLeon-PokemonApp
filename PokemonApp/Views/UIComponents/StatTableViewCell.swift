//
//  StatTableViewCell.swift
//  PokemonApp
//
//  Created by Nicolás Bocanegra León on 4/16/22.
//

import UIKit

class StatTableViewCell: UITableViewCell {
    @IBOutlet weak var statUILabel: UILabel!
    @IBOutlet weak var baseStatUILabel: UILabel!
    @IBOutlet weak var barIndicatorUIView: UIView!
    @IBOutlet weak var barBackgroundUIView: UIView!
    @IBOutlet weak var barIndicatorTrailingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with stat: String, baseStat: Int) {
        self.statUILabel.text = stat.capitalized
        self.baseStatUILabel.text = String(baseStat)
        let barPercentage: CGFloat = CGFloat(baseStat) / 2.5
        self.barIndicatorTrailingConstraint.constant = barBackgroundUIView.frame.width * (100 - barPercentage) / 100
        self.barIndicatorUIView.layer.cornerRadius = self.barIndicatorUIView.layer.frame.height / 2
        self.barBackgroundUIView.layer.cornerRadius = self.barBackgroundUIView.layer.frame.height / 2
    }
    
}
