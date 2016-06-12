//
//  RequestClient.swift
//  Memo
//
//  Created by zyf on 16/6/8.
//  Copyright © 2016年 hui. All rights reserved.
//
import UIKit

protocol RequestClientDelegate{

}

class RequestClient: AFHTTPSessionManager {
    
    var delegate:RequestClientDelegate?
    
    class var sharedInstance:RequestClient {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance:RequestClient? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            let url:NSURL = NSURL(string: "http://10.1.32.39/")!
            Static.instance = RequestClient(baseURL: url)
            Static.instance?.requestSerializer = AFHTTPRequestSerializer()
            Static.instance?.responseSerializer = AFHTTPResponseSerializer()
            let resSet = NSSet(array: ["text/html"])
            Static.instance!.responseSerializer.acceptableContentTypes = resSet as? Set<String>
        })
        //返回本类的一个实例
        return Static.instance!
    }
}
