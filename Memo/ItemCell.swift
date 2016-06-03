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

//    var currentItem:ItemModel!
//    var currentFrameInfo:CellFrameInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
//        let longPress = UILongPressGestureRecognizer(target: self, action: "editCell:")
//        longPress.minimumPressDuration = 0.5
//        longPress.delegate = self
//        self.addGestureRecognizer(longPress)
    }
    
//    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return super.gestureRecognizerShouldBegin(gestureRecognizer)
//        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
//            let translation = panGesture.translationInView(self.superview)
//            return fabs(translation.x) > fabs(translation.y) && translation.x > 0 ? true : super.gestureRecognizerShouldBegin(gestureRecognizer)
//        }
//        else {
//            return super.gestureRecognizerShouldBegin(gestureRecognizer)
//        }
//    }
    
//    func setCellData(data:ItemModel, frameInfo:CellFrameInfo){
//        self.currentItem = data
//        self.currentFrameInfo = frameInfo
//        self.layoutIfNeeded()
//    }
    
//    override func layoutSubviews() {
//        self.avaterImageView.frame = self.currentFrameInfo.avaterImageFrame
//    }
    
//    func editCell(sender: UILongPressGestureRecognizer){
//        if sender.state == UIGestureRecognizerState.Began {
//            print("longPress")
//        }
//    }
}
