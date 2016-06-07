//
//  ItemCell.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

protocol ItemCellDelegate{
    func switchState(button:UIButton, createTime:String)
}

class ItemCell: UITableViewCell{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var stateButton: UIButton!
    var createTime:String!
    var delegate:ItemCellDelegate?
    
    
//    var currentFrameInfo:CellFrameInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        stateButton.addTarget(self, action: Selector("handleButtonClick:"), forControlEvents: .TouchUpInside)
    }
    
    func handleButtonClick(button:UIButton){
        self.delegate?.switchState(button, createTime: self.createTime)
    }
    
    
//    override func layoutSubviews() {
//        self.detailImage.frame = CGRectMake(342, 15, 12, 12)
//    }
    
}
