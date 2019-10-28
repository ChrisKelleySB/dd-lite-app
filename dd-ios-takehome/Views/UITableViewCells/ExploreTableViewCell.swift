//
//  ExploreTableViewCell.swift
//  dd-ios-takehome
//
//  Created by Christopher Kelley on 10/25/19.
//  Copyright © 2019 Christopher Kelley. All rights reserved.
//

import UIKit
import SDWebImage

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    static var reuseIdentifier: String {
        return "exploreCell"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Rounding imageView edges
        self.mainImageView.layer.cornerRadius = 8.0
        self.mainImageView.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layoutViewForItem(exploreItem: ExploreItem) {
        //Retrieve item information and populate cell..
        self.titleLabel.text = exploreItem.name
        self.descriptionLabel.text = exploreItem.description

        if let exploreImageUrl = exploreItem.exploreImageUrl,
            let url = URL(string: exploreImageUrl) {
            self.mainImageView.sd_setImage(with: url, completed: nil)
        }
        
        if let time = exploreItem.deliveryTime {
            self.timeLabel.text = "\(time) min"
        } else {
            self.timeLabel.text = ""
        }
        
        if let fee = exploreItem.deliveryFee {
            if fee > 0 {
                self.feeLabel.text = formatCurrencyForCell(fee: Double(fee) / Double(100))
            } else {
                self.feeLabel.text = "Free Delivery"
            }
        }
    }
    
    func formatCurrencyForCell(fee: Double) -> String {
        return String(format: "$%.2f", fee)
    }
}
