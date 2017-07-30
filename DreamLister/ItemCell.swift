//
//  ItemCell.swift
//  DreamLister
//
//  Created by Ismail Hossain on 2017-07-29.
//  Copyright © 2017 Ismail Hossain. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
