//
//  ItemModel.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class ItemModel: NSObject {
    var title:String = ""
    var content:String = ""
    var createTime:String = ""
    var lastEditTime:String = ""
    var alertTime = ""
    var level:Int = 5
    var state:Int = 0    //state范围0-3，两个二进制位分别表示 未完成/已完成、未删除/已删除
    
    override init(){
        super.init()
    }
    
    convenience init(title:String, content:String, createTime:String, lastEditTime:String, alertTime:String, level:Int, state:Int){
        self.init()
        self.title = title
        self.content = content
        self.createTime = createTime
        self.lastEditTime = lastEditTime
        self.alertTime = alertTime
        self.level = level
        self.state = state
    }
}
