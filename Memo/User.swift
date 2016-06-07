//
//  User.swift
//  MySqliteConnect
//
//  Created by tjise on 16/5/27.
//  Copyright © 2016年 tjise. All rights reserved.
//

import UIKit

class User: NSObject {

    var phoneNumber:String = ""
    var avaterImage:UIImage = UIImage()
    var nickName:String = ""
    var loginState:String = "0"
    
    convenience init(phoneNumber:String, avaterImage:UIImage, nickName:String,loginState:String){
        self.init()
        self.phoneNumber = phoneNumber
        self.avaterImage = avaterImage
        self.nickName = nickName
        self.loginState = loginState
    }
}
