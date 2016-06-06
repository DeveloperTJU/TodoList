//
//  ItemCell.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell, BaseViewControllerDelegate{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var detailImage: UIImageView!
    var createTime:String!
    var delegate:BaseViewControllerDelegate!

//    var currentFrameInfo:CellFrameInfo!
    
    func switchState() {
        self.delegate.switchState()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
    }
    
    
//    override func layoutSubviews() {
//        self.detailImage.frame = CGRectMake(342, 15, 12, 12)
//    }
    
}
