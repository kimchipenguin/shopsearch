//
//  NearbyShopsTableViewCell.swift
//  haendlersuche
//
//  Copyright © 2016 Matthias Jaap. All rights reserved.
//

import UIKit

class NearbyShopsTableViewCell: UITableViewCell {

	@IBOutlet weak var nearByShopAdress: UILabel!
	@IBOutlet weak var nearByShopTitle: UILabel!
	@IBOutlet weak var shopDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
