//
//  MyRect.swift
//  Memo
//
//  Created by hui on 16/6/3.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class MyRect: UIView {
    
    var color = UIColor.whiteColor()
    var withShadow = true
    
    override init(frame: CGRect) {      //默认圆角、白色、有阴影
        super.init(frame: frame)
        self.setShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setShadow()
    }
    
    func setShadow() -> Void{
        if withShadow{
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOffset = CGSizeMake(0, 0.4)
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = 0.2
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
    convenience init(frame:CGRect, color:UIColor, withShadow:Bool){
        self.init(frame: frame)
        self.color = color
        self.withShadow = withShadow
    }
    
    override func drawRect(rect: CGRect) {
        let pathRect = CGRectInset(self.bounds, 1, 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 3)
        path.lineWidth = 0
        self.color.setFill()
        path.fill()
        path.stroke()
    }
}
