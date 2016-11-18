//
//  CellMasterView.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/13/16.
//  Copyright © 2016 Alexander Iashchuk. All rights reserved.
//

import UIKit

class CellMasterView: UITableViewCell {
    
    @IBOutlet weak var cellInformationView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellDateTextLabel: UILabel!
    @IBOutlet weak var cellDurationTextLabel: UILabel!
    @IBOutlet weak var cellTopTextLabel: UILabel!
    @IBOutlet weak var cellBottomTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
