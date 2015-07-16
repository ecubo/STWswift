//
//  CustomHeaderTableViewCell.swift
//  Tutorial-MapKitSwift
//
//  Created by Cubo, Emilio on 18/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class CustomHeaderTableViewCell: UITableViewCell {

    @IBOutlet var imgHeader: UIImageView!
    @IBOutlet var titleHeader: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
