//
//  CellMasterView.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/13/16.
//  Copyright © 2016 Alexander Iashchuk. All rights reserved.
//

import UIKit

class CellMasterView: UITableViewCell {
    
    @IBOutlet weak var cellTextView: UIView!
    @IBOutlet weak var cellInformationView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellDateTextLabel: UILabel!
    @IBOutlet weak var cellDurationTextLabel: UILabel!
    @IBOutlet weak var cellTopTextLabel: UILabel!
    @IBOutlet weak var cellBottomTextLabel: UILabel!
    @IBOutlet weak var cellSpeechTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
