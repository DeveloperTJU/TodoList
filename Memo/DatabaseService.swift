//
//  databaseService.swift
//  Memo
//
//  Created by hui on 16/5/26.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class DatabaseService: NSObject {
    
    var database:FMDatabase!
    var dbQueue:FMDatabaseQueue!
    class var sharedInstance:DatabaseService {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance:DatabaseService? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = DatabaseService()
        })
        return Static.instance!
    }
    
    override init(){
        super.init()
        self.database = self.getDatabase()
        self.dbQueue = self.getDatabaseQueue()
    }
    
    func getDatabase() -> FMDatabase{
        let fileManager = NSFileManager.defaultManager()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !fileManager.fileExistsAtPath(appDelegate.databasePath){
            let db = FMDatabase(path: appDelegate.databasePath)
            if db == nil{
                print("Error:\(db.lastErrorMessage())")
            }
            if db.open(){
                let sqlStr = "CREATE TABLE IF NOT EXISTS USER(UID TEXT, PHONENUMBER TEXT, NICKNAME TEXT, CURRENTUSER INT, PRIMARY KEY(UID))"
                if !db.executeUpdate(sqlStr, withArgumentsInArray: []) {
                    print("Error:\(db.lastErrorMessage())")
                }
                db.close()
            }
            else{
                print("Error:\(db.lastErrorMessage())")
            }
        }
        return FMDatabase(path: appDelegate.databasePath)
    }
    
    func getDatabaseQueue() -> FMDatabaseQueue {
        return FMDatabaseQueue(path: (UIApplication.sharedApplication().delegate as! AppDelegate).databasePath)
    }
    
    //查询当前已登录用户，如存在，设置UserInfo，如不存在则返回false
    func hasCurrentUser() -> Bool{
        let sqlStr = "SELECT * FROM USER WHERE CURRENTUSER = 1"
        self.database.open()
        let rs = self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        if rs.next(){
            UserInfo.UID = rs.stringForColumn("UID")
            UserInfo.phoneNumber = rs.stringForColumn("PHONENUMBER")
            UserInfo.nickname = rs.stringForColumn("NICKNAME")
            database.close()
            return true
        }
        else {
            database.close()
            return false
        }
    }
    
    //如果首次登录，初始化当前用户的数据表
    func initDataTable() -> Bool{
        self.database.open()
        let sqlStr = "CREATE TABLE IF NOT EXISTS data_\(UserInfo.phoneNumber.md5)(TITLE TEXT, CONTENT TEXT, CREATE_TIME TEXT, LAST_EDIT_TIME TEXT, TIMESTAMP TEXT, ALERT_TIME TEXT, LEVEL INT, STATE INT, PRIMARY KEY(CREATE_TIME))"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [])
        self.database.close()
        return succeed
    }
    
    //新注册可选是否导入访客数据
    func importDataFromVisitor() -> Bool{
        self.database.open()
        var sqlStr = "SELECT * FROM data_\("Visitor".md5)"
        let rs = self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        var dataArr = [ItemModel]()
        while rs.next(){
            dataArr.append(ItemModel(title: rs.stringForColumn("TITLE"), content: rs.stringForColumn("CONTENT"), createTime: rs.stringForColumn("CREATE_TIME"), lastEditTime: rs.stringForColumn("LAST_EDIT_TIME"), timestamp: rs.stringForColumn("TIMESTAMP"), alertTime: rs.stringForColumn("ALERT_TIME"), level: rs.longForColumn("LEVEL"), state: rs.longForColumn("STATE")))
        }
        var succeed = true
        sqlStr = "INSERT INTO data_\(UserInfo.phoneNumber.md5) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        for data in dataArr{
            if !self.database.executeUpdate(sqlStr, withArgumentsInArray: [data.title, data.content, data.createTime, data.lastEditTime, data.timestamp, data.alertTime, data.level, data.state]){
                succeed = false
            }
        }
        self.database.close()
        return succeed
    }
    
    //新增用户
    func insertUser(UID:String, phoneNumber:String, nickname:String, isCurrentUser:Int) -> Bool{
        self.database.open()
        let sqlStr = "INSERT INTO USER VALUES (?, ? ,?, ?)"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [UID, phoneNumber, nickname, isCurrentUser])
        self.database.close()
        return succeed
    }
    
    //新增或更新用户信息
    func refreshUser(UID:String, phoneNumber:String, nickname:String, isCurrentUser:Int) -> Bool{
        self.database.open()
        var sqlStr = "DELETE FROM USER WHERE UID = ?"
        self.database.executeUpdate(sqlStr, withArgumentsInArray: [UID])
        sqlStr = "INSERT INTO USER VALUES (?, ? ,?, ?)"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [UID, phoneNumber, nickname, isCurrentUser])
        self.database.close()
        return succeed
    }
    
    //更新当前用户的昵称
    func updateNickname() -> Bool{
        self.database.open()
        let sqlStr = "UPDATE USER SET NICKNAME=? WHERE UID='\(UserInfo.UID)'"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [UserInfo.nickname])
        self.database.close()
        return succeed
    }
    
    //更新当前用户的登录/注销状态
    func updateLoginState(isCurrentUser:Int) -> Bool{
        self.database.open()
        let sqlStr = "UPDATE USER SET CURRENTUSER=? WHERE UID='\(UserInfo.UID)'"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [isCurrentUser])
        self.database.close()
        return succeed
    }
    
    func hasVisitorData() -> Bool{
        self.database.open()
        var sqlStr = "SELECT * FROM USER WHERE PHONENUMBER='Visitor'"
        let rsUser = self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        if rsUser.next(){
            sqlStr = "SELECT * FROM data_\("Visitor".md5)"
            let rsData = self.database.executeQuery(sqlStr, withArgumentsInArray: [])
            if rsData.next(){
                self.database.close()
                return true
            }
        }
        self.database.close()
        return false
    }
    
    //选取当前用户所有数据准备上传
    func selectLocalData() -> Dictionary<String,AnyObject> {
        self.database.open()
        var dictArr = Dictionary<String, AnyObject>()
        let sqlStr = "SELECT * FROM data_\(UserInfo.phoneNumber.md5)"
        let rs = self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        while rs.next(){
            let data:NSDictionary = ["title": (rs.stringForColumn("TITLE")), "content": rs.stringForColumn("CONTENT"), "createtime": rs.stringForColumn("CREATE_TIME"), "lastedittime": rs.stringForColumn("LAST_EDIT_TIME"), "timestamp": rs.stringForColumn("TIMESTAMP"), "alerttime": rs.stringForColumn("ALERT_TIME"), "level": rs.longForColumn("LEVEL"), "state": rs.longForColumn("STATE")]
            dictArr["\(rs.stringForColumn("CREATE_TIME"))"] = data
        }
        self.database.close()
        return dictArr
    }
    
    //新建任务
    func insertInDB(data:ItemModel) -> Bool {
        self.database.open()
        let sqlStr = "INSERT INTO data_\(UserInfo.phoneNumber.md5) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [data.title, data.content, data.createTime, data.lastEditTime, data.timestamp, data.alertTime, data.level, data.state])
        self.database.close()
        return succeed
    }
    
    //参数为创建时间
    func deleteInDB(createTime:String) -> Bool {
        self.database.open()
        let sqlStr = "DELETE FROM data_\(UserInfo.phoneNumber.md5) WHERE CREATE_TIME=?"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [createTime])
        self.database.close()
        return succeed
    }
    
    //同步成功后清除本地已删除任务
    func clearDeletedData() -> Bool {
        self.database.open()
        let sqlStr = "DELETE FROM data_\(UserInfo.phoneNumber.md5) WHERE STATE=1 OR STATE=3"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [])
        self.database.close()
        return succeed
    }
    
    //将修改后的data作为参数，createTime是主键不允许修改。
    func updateInDB(data:ItemModel) -> Bool {
        self.database.open()
        let sqlStr = "UPDATE data_\(UserInfo.phoneNumber.md5) SET TITLE=?, CONTENT=?, LAST_EDIT_TIME=?, TIMESTAMP=?, ALERT_TIME=?, LEVEL=?, STATE=? WHERE CREATE_TIME=?"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [data.title, data.content, data.lastEditTime, data.timestamp, data.alertTime, data.level, data.state, data.createTime])
        self.database.close()
        return succeed
    }
    
    //selectAllInDB().0 是未完成列表，selectAllInDB().1 是已完成列表。
    func selectAllInDB() -> ([ItemModel], [ItemModel]) {
        self.database.open()
        let sqlStr = "SELECT * FROM data_\(UserInfo.phoneNumber.md5) ORDER BY LEVEL DESC, LAST_EDIT_TIME DESC"
        let rs =  self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        var unfinished:[ItemModel] = [ItemModel]()
        var finished:[ItemModel] = [ItemModel]()
        while rs.next(){
            let state = rs.longForColumn("STATE")
            let data = ItemModel(title: rs.stringForColumn("TITLE"), content: rs.stringForColumn("CONTENT"), createTime: rs.stringForColumn("CREATE_TIME"), lastEditTime: rs.stringForColumn("LAST_EDIT_TIME"), timestamp: rs.stringForColumn("TIMESTAMP"), alertTime: rs.stringForColumn("ALERT_TIME"), level: rs.longForColumn("LEVEL"), state: state)
            if state & 1 == 0{  //未删除
                if rs.longForColumn("state") & 2 == 2{ //已完成
                    finished.append(data)
                }
                else{
                    unfinished.append(data)
                }
            }
        }
        self.database.close()
        return (unfinished, finished)
    }
    
}
