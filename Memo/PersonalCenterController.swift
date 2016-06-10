//
//  PersonalCenterViewController.swift
//  MySqliteConnect
//
//  Created by tjise on 16/5/27.
//  Copyright © 2016年 tjise. All rights reserved.
//

import UIKit

class PersonalCenterController: UIViewController , UIActionSheetDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,BackForNewPasswordDelegate,ChangeNickNameDelegate{
    
    var mainTableView:UITableView!
    var imageView = UIImageView()
    var dataArrs:[[String]] = [[String]]()
    var nickNameText:UILabel!
    
    //由于同一时间内存中只有一个User，所以删除User模型，使用全局常量UserInfo存储当前用户信息，用户中心只用到nickName和phoneNumber。头像使用UserInfo.phoneNumber.md5作为文件名，从服务器获得并存入资源文件夹。
    //请设置AutoLyout，简单使用self.view.size设置相应的frame即可。有问题请直接找我。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化数据
        self.title = "个人中心"
        initDataArrs()
        self.setTableView()
        //添加头像
        self.setAvaterImage()
        self.setNickNameText()
        //添加返回按钮
        self.addLeftButtonItem()
    }
    
    //添加tableView
    func setTableView(){
        let tableViewFrame:CGRect = CGRectMake(8, 0, self.view.bounds.width-16, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.mainTableView.scrollEnabled = false
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    //添加返回按钮
    func addLeftButtonItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "backMain")
    }
    
    //返回按钮事件
    func backMain(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //初始化tableView
    func initDataArrs() {
        let arr0 = [""]
        let arr1 = ["当前账号","修改密码"]
        let arr2 = ["清理缓存"]
        let arr3 = ["关于我们"]
        let arr4 = ["注   销"]
        self.dataArrs = [arr0,arr1,arr2,arr3,arr4]
    }
    
    //设置第一行头像
    func setAvaterImage(){
        self.imageView = UIImageView(frame: CGRectMake(15, 10, 80, 80))
        self.imageView.layer.cornerRadius = CGRectGetHeight(imageView.bounds)/2
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderColor = UIColor.grayColor().CGColor
        self.imageView.layer.borderWidth = 1
        self.imageView.userInteractionEnabled = UserInfo.phoneNumber != "Visitor"
        let image = UIImage(named: UserInfo.phoneNumber.md5)
        let scale = image!.size.width > image!.size.height ? image!.size.height/80 : image!.size.width/80
        self.imageView.image = UIImage(CGImage: image!.CGImage!, scale: scale, orientation: .Up)
        //添加图像手势
        let imageClickGesture = UITapGestureRecognizer(target: self, action: "changeAvaterImage:")
        self.imageView.addGestureRecognizer(imageClickGesture)
    }
    
    //设置昵称
    func setNickNameText(){
        let textFrame:CGRect = CGRectMake(120, 0, 450, 100)
        self.nickNameText = UILabel(frame: textFrame)
        self.nickNameText.text = UserInfo.nickName
        self.nickNameText.userInteractionEnabled = UserInfo.phoneNumber != "Visitor"
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onNickNameClicked:")
        self.nickNameText.addGestureRecognizer(tapGesture)
    }
    
    //修改头像
    func changeAvaterImage(gesture:UITapGestureRecognizer){
        let actionSheet = UIActionSheet(title: "获取图像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "从相册选择", otherButtonTitles: "拍照")
        actionSheet.tag  = 1000
        actionSheet.showInView(self.view)
    }
    
    //打开相册或相机
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.tag == 1000{
            var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            switch(buttonIndex){
            case 0:
                sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                //跳转到相册或相册页面
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = sourceType
                self.presentViewController(imagePickerController, animated: true, completion: {
                })
            case 2:
                if UIImagePickerController.isSourceTypeAvailable(.Camera){
                    sourceType = .Camera
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.allowsEditing = true
                    imagePickerController.sourceType = sourceType
                    self.presentViewController(imagePickerController, animated: true, completion: {
                    })
                }
            default:
                break
            }
        }
    }
    
    //显示图像
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true) {
            
        }
        //此处调用上传，失败则提示用户修改头像失败
        //如上传成功，将头像保存至本地资源文件夹，名称为UserInfo.phoneNumber.md5
        let scale = image.size.width > image.size.height ? image.size.height/80 : image.size.width/80
        self.imageView.image = UIImage(CGImage: image.CGImage!, scale: scale, orientation: .Up)
    }
    
    //由于该方法会导致失真，不推荐使用该方法，请使用UIImage(CGImage: image.CGImage!, scale: scale, orientation: .Up)代替。
//    func compressImage(originImage:UIImage ,toSize size:CGSize) -> UIImage {
//        //创建一个基于位图的上下文
//        UIGraphicsBeginImageContext(size)
//        let rect = CGRectMake(0, 0, size.width, size.height)
//        originImage.drawInRect(rect)
//        //获取新的图片
//        let compressedImg = UIGraphicsGetImageFromCurrentImageContext()
//        //销毁上下文
//        UIGraphicsEndImageContext()
//        return compressedImg
//    }
    
    //控制分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArrs.count
    }
    
    //控制行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArrs[section].count
    }
    
    //控制分区头
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    //设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return 100
        }
        else{
            return 42
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    //设置分区头样式
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clearColor()
        view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 42)
        return view
    }

    //控制样式
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorStyle = .SingleLine
        let frame:CGRect = CGRectMake(20, 20, 20, 42)
        var cell = UITableViewCell(frame:frame)
        let sectionArr = dataArrs[indexPath.section]
        cell.textLabel?.text = sectionArr[indexPath.row]
        if indexPath.section == 1 && indexPath.row == 0{
            let frame:CGRect = CGRectMake(self.view.bounds.size.width - 140, 5, 100, 42)
            let phoneNumberText = UILabel(frame: frame)
            phoneNumberText.text = UserInfo.phoneNumber
            phoneNumberText.textAlignment = .Right
            phoneNumberText.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            cell.addSubview(phoneNumberText)
        }
        else if indexPath.section == 4 && indexPath.row == 0{
            if UserInfo.phoneNumber == "Visitor"{
                cell.backgroundColor = UIColor(red: 129/255, green: 192/255, blue: 23/255, alpha: 1.0)
                cell.textLabel?.text = "我 要 注 册"
            }
            else{
                cell.backgroundColor = .redColor()
            }
            cell.textLabel?.textAlignment = .Center
        }
        else{
            let detailImageView = UIImageView(image: UIImage(named: "右箭头"))
            detailImageView.frame = CGRectMake(self.view.bounds.size.width - 40, (cell.frame.minY + cell.frame.maxY) / 2 - 6, 12, 12)
            if indexPath.section == 0 && indexPath.row == 0{
                let frame:CGRect = CGRectMake(20, 0, 200, 200)
                cell = UITableViewCell(frame: frame)
                detailImageView.frame = CGRectMake(self.view.bounds.size.width - 40, 44, 12, 12)
                cell.addSubview(imageView)
                cell.addSubview(nickNameText)
                nickNameText.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
                cell.selectionStyle = .None
            }
            cell.addSubview(detailImageView)
        }
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        cell.layer.cornerRadius = 3
        return cell
    }
    
    //tableView点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.selectionStyle = .Default
        switch(indexPath.section){
        case 1:
            if indexPath.row == 0{
            }else if indexPath.row == 1 && UserInfo.phoneNumber != "Visitor"{
                let reachability = Reachability.reachabilityForInternetConnection()
                if reachability!.isReachable(){
                    let ChangePassVC = ChangePaswordController()
                    ChangePassVC.delegate = self
                    ChangePassVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(ChangePassVC, animated: true)
                }else{
                    let alert = UIAlertController(title: "网络提示", message: "无可用网络，不可修改密码", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        case 2:
            self.clearCache()
        case 3:
            let alert = UIAlertController(title: "", message: "天软玩头盔开发团队", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        case 4:
            if UserInfo.phoneNumber == "Visitor"{
                UserInfo.UID = nil
                UserInfo.phoneNumber = nil
                UserInfo.nickName = nil
                self.presentViewController(PhoneNumberViewController(), animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "提示", message: "确定注销？", preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: "确定", style: .Default, handler: { (confirm) in
                    if DatabaseService.sharedInstance.updateUser(0){
                        UserInfo.UID = nil
                        UserInfo.phoneNumber = nil
                        UserInfo.nickName = nil
                        self.presentViewController(LogInViewController(), animated: true, completion: nil)
                    }
                    else{
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text
                        hud.label.text = "注销失败"
                        hud.hideAnimated(true, afterDelay: 0.5)
                    }
                })
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        default:
            break
        }
        cell.selectionStyle = .None
    }
    
    //清理缓存
    func clearCache(){
        //取出cache文件路径
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first! as String
        //打印路径
        print(cachePath)
        //取出文件夹下所有文件数组
        let files = NSFileManager.defaultManager().subpathsAtPath(cachePath)
        //统计文件夹所有文件大小
        var big = Int()
        for file in files!{
            //拼接出文件路径
            let path = cachePath.stringByAppendingFormat("/\(file)")
            //取出文件属性
            //print(path)
            let floder = try! NSFileManager.defaultManager().attributesOfItemAtPath(path)
            //用无组取出文件大小属性
            for (abc,bcd) in floder{
                if abc == NSFileSize{
                    print("\(path)大小为\(bcd.integerValue)")
                    big += bcd.integerValue
                }
            }
        }
        //提示框
        var message = "\(big/(1024))K缓存"
        if big/(1024*1024) >= 1 {
            message = "\(big/(1024*1024))M缓存"
        }
        let alert = UIAlertController(title: "清除缓存", message: message, preferredStyle: .Alert)
        let alertConirm = UIAlertAction(title: "确定", style: .Default) { (alertConfirm) in
            //点击确定时开始删除
            for file in files!{
                let path = cachePath.stringByAppendingFormat("/\(file)")
                if NSFileManager.defaultManager().fileExistsAtPath(path){
                    try! NSFileManager.defaultManager().removeItemAtPath(path)
                }
            }
        }
        alert.addAction(alertConirm)
        let cancel = UIAlertAction(title: "取消", style: .Cancel) { (no) in
        }
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true) {}
    }
    
    
    //nickName点击手势
    func onNickNameClicked(tapGesture:UITapGestureRecognizer){
        let changeNickNameVC = ChangeNickNameController()
        changeNickNameVC.delegate = self
        self.navigationController?.pushViewController(changeNickNameVC, animated: true)
    }
    
    //接受修改密码返回值协议
    func setNewPassword(password:String){
        //self.currentUser.password = password
        print("修改后密码为\(password)")
    }
    
    //接受修改昵称返回值
    func setNewNickName(newNickName: String) {
        self.nickNameText.text = newNickName
    }
}
