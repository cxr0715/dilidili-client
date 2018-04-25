//
//  HomeViewCollectionCell.swift
//  dilidili-client
//
//  Created by YYInc on 2018/4/25.
//  Copyright © 2018年 caoxuerui. All rights reserved.
//

import UIKit

class HomeViewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var videoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateImageAndTitleCell(imageURL:String, title:String) {
        
        let url:NSURL = NSURL(string: imageURL)!
        do {
            let imageData:NSData = try NSData(contentsOf: url as URL)
            self.videoImage.image = UIImage(data: imageData as Data)
        } catch  {
            print("图片请求失败")
        }
        self.videoLabel.text = title
    }

}
