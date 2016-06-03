//
//  DatabaseService.swift
//  Memo
//
//  Created by hui on 16/5/26.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class DataBaseService: NSObject {
    
    class  func getDataBase() -> FMDatabase{
        let fileManager = NSFileManager.defaultManager()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !fileManager.fileExistsAtPath(appDelegate.dataBasePath){
            let db = FMDatabase(path: appDelegate.dataBasePath)
            if db == nil{
                print("Error:\(db.lastErrorMessage())")
            }
            if db.open(){
                let sqlStr = "CREATE TABLE IF NOT EXISTS TASK(ID TEXT, TIME TEXT, CONTENT TEXT, CLASS TEXT, PRIMARY KEY(ID)"
                if !db.executeUpdate(sqlStr, withArgumentsInArray: []) {
                    print("Error:\(db.lastErrorMessage())")
                }
                db.close()
            }
            else{
                print("Error:\(db.lastErrorMessage())")
            }
        }
        return FMDatabase(path: appDelegate.dataBasePath)
    }
    
    class func getDataBaseQueue() -> FMDatabaseQueue {
        return FMDatabaseQueue(path: (UIApplication.sharedApplication().delegate as! AppDelegate).dataBasePath)
    }
    
}
