//
//  ShopTableViewCell.swift
//  haendlersuche
//
//  Copyright © 2016 Matthias Jaap. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

	@IBOutlet weak var vendorTitle: UILabel!
	@IBOutlet weak var vendorAdress: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
