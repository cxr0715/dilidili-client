//
//  VideoPlayTableViewCell.swift
//  dilidili-client
//
//  Created by YYInc on 2018/4/26.
//  Copyright © 2018年 caoxuerui. All rights reserved.
//

import UIKit

class VideoPlayTableViewCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func updateNumberAndTitleLabel(number:String, title:String) {
        self.numberLabel.text = number
        self.titleLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
