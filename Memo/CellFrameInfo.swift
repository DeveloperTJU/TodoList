//
//  CellFrameInfo.swift
//  Memo
//
//  Created by hui on 16/5/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class CellFrameInfo: NSObject {
    var cellHeight:CGFloat = 0
    var avaterImageFrame:CGRect = CGRect()
    var timeLabelFrame:CGRect = CGRect()
    var titleFrame:CGRect = CGRect()
    var contentFrame:CGRect = CGRect()
    
    let kSubViewHorizontalMargin:CGFloat = CGFloat(10)
    let kSubViewVerticalMargin:CGFloat = CGFloat(10)
    let kAvaterImageViewWidth:CGFloat = CGFloat(50)
    let kAvaterImageViewHeight:CGFloat = CGFloat(50)
    
    init(data:ItemModel){
        self.avaterImageFrame = CGRectMake(kSubViewHorizontalMargin, kSubViewVerticalMargin, kAvaterImageViewWidth, kAvaterImageViewHeight)
    }
}
