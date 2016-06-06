//
//  ItemCell.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var stateButton: UIButton!
    var createTime:String!

//    var currentFrameInfo:CellFrameInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
    }
    
    
//    override func layoutSubviews() {
//        self.detailImage.frame = CGRectMake(342, 15, 12, 12)
//    }
    
}
