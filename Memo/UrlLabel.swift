//
//  UrlLabel.swift
//  Memo
//
//  Created by tjise on 16/6/13.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class UrlLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "onLabelClicked:")
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let ctx:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetLineWidth(ctx, 0.5)
        let font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        self.textAlignment = .Left
        self.font = font
        let text:NSString = self.text! as NSString
        let fontSize:CGSize = text.sizeWithAttributes(["sizeWithFont":self.font,"forWidth":self.bounds.size.width])
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        let leftPoint = CGPointMake(0, self.frame.size.height/2+fontSize.height/2)
        let rightPoint = CGPointMake(fontSize.width,self.frame.size.height/2+fontSize.height/2)
        CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y)
        CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y)
        CGContextStrokePath(ctx)
        super.drawRect(rect)
    }
 
    func onLabelClicked(gesture:UITapGestureRecognizer){
        let result = self.text! as String
        let url:NSURL = NSURL(string: "http://\(result)")!
        UIApplication.sharedApplication().openURL(url)
        self.textColor = UIColor.redColor()
    }
    

}
