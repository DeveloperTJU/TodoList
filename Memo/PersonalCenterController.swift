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
    var imageView:UIImageView!
    var currentUser:User!
    var dataArrs:[[String]] = [[String]]()
    var nickNameText:UILabel!
    var userController:UserViewController = UserViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image:UIImage = UIImage(imageLiteral: "finished")
        self.currentUser = User(phoneNumber: "13672006807", avaterImage: image, nickName: "飞翔的企鹅",loginState:"1")
        self.currentUser.phoneNumber = userController.currentUser
        //初始化数据
        self.title = "个人中心"
        initDataArrs()
        self.setTableView()
        self.navigationController?.navigationBar.backgroundColor = UIColor.orangeColor()
        
        //添加头像
        self.setAvaterImage()
        self.setNickNameText()
        //添加返回按钮
        self.addLeftButtonItem()
        self.setBackGround()
        
    }
    
    //设置背景
    func setBackGround(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")!.drawInRect(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        self.mainTableView.backgroundColor = UIColor.clearColor()
        self.mainTableView.separatorStyle = .None
    }
    
    //添加tableView
    func setTableView(){
        let tableViewFrame:CGRect = CGRectMake(10, 10, self.view.bounds.width-20, self.view.bounds.height-10)
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        self.mainTableView.backgroundColor = UIColor.whiteColor()
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.view.addSubview(self.mainTableView)
    }
    
    //添加返回按钮
    func addLeftButtonItem(){
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backMain")
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    //返回按钮事件
    func backMain(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //初始化tableView
    func initDataArrs() {
        let arr0 = [""]
        let arr1 = ["登录账号","修改密码"]
        let arr2 = ["清理缓存"]
        let arr3 = ["关于我们"]
        let arr4 = ["退出"]
        self.dataArrs = [arr0,arr1,arr2,arr3,arr4]
    }
    
    //设置第一行头像
    func setAvaterImage(){
        let avaterImage = self.currentUser.avaterImage
        let fixedImage = self.compressImage(avaterImage, toSize: CGSizeMake(80, 80))
        let imageX:CGFloat = 15
        let imageWidth:CGFloat = 80
        let imageFrame:CGRect = CGRectMake(imageX, 10, imageWidth, imageWidth)
        self.imageView = UIImageView(frame: imageFrame)
        self.imageView.layer.cornerRadius = CGRectGetHeight(imageView.bounds)/2
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderColor = UIColor.grayColor().CGColor
        self.imageView.layer.borderWidth = 3
        self.imageView.image = fixedImage
        self.imageView.userInteractionEnabled = true
        //添加图像手势
        let imageClickGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "changeAvaterImage:")
        self.imageView.addGestureRecognizer(imageClickGesture)
    }
    
    //
    func setNickNameText(){
        let textFrame:CGRect = CGRectMake(120, 0, 450, 100)
        self.nickNameText = UILabel(frame: textFrame)
        self.nickNameText.text = self.currentUser.nickName
        self.nickNameText.userInteractionEnabled = true
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onNickNameClicked:")
        self.nickNameText.addGestureRecognizer(tapGesture)
    }
    
    //修改头像
    func changeAvaterImage(gesture:UITapGestureRecognizer){
        let actionSheet:UIActionSheet = UIActionSheet(title: "获取图像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "从相册选择", otherButtonTitles: "拍照")
        actionSheet.tag  = 1000
        actionSheet.showInView(self.view)
    }
    
    //打开相册或相机
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.tag == 1000{
            var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            switch(buttonIndex){
            case 0:
                print("点击了本地获取")
                sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                //跳转到相册或相册页面
                let imagePickerController:UIImagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = sourceType
                self.presentViewController(imagePickerController, animated: true, completion: {
                })
            case 1:
                print("点击了取消按钮")
            case 2:
                print("点击了相机获取")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                    sourceType = UIImagePickerControllerSourceType.Camera
                    let imagePickerController:UIImagePickerController = UIImagePickerController()
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
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true) {
            
        }
        self.currentUser.avaterImage = image
        let fixedImage = self.compressImage(image, toSize: CGSizeMake(80, 80))
        self.imageView.image = fixedImage
    }
    
    //压缩图像
    func compressImage(originImage:UIImage ,toSize size:CGSize) -> UIImage {
        //创建一个基于位图的上下文
        UIGraphicsBeginImageContext(size)
        let rect = CGRectMake(0, 0, size.width, size.height)
        originImage.drawInRect(rect)
        //获取新的图片
        let compressedImg = UIGraphicsGetImageFromCurrentImageContext()
        //销毁上下文
        UIGraphicsEndImageContext()
        return compressedImg
    }
    
    
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
        if section == 0{
            return ""
        }
        return "  "
    }
    
    //设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return 100
        }
        else{
            return 40
        }
    }
    
    //设置分区头样式
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40)
        return view
    }

    //控制样式
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        let frame:CGRect = CGRectMake(20, 20, 20, 40)
        var cell:UITableViewCell = UITableViewCell(frame:frame)
        let sectionArr = dataArrs[indexPath.section]
        cell.textLabel?.text = sectionArr[indexPath.row]
        //显示头像和用户名。
        if indexPath.section == 0 && indexPath.row == 0{
            let frame:CGRect = CGRectMake(20, 0, 200, 200)
            cell = UITableViewCell(frame: frame)
            cell.addSubview(imageView)
            cell.addSubview(nickNameText)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if indexPath.section == 1 && indexPath.row == 0{
            let frame:CGRect = CGRectMake(250, 5, 100, 30)
            let phoneNumberText:UILabel = UILabel(frame: frame)
            phoneNumberText.text = self.currentUser.phoneNumber
            phoneNumberText.textAlignment = NSTextAlignment.Right
            cell.addSubview(phoneNumberText)
        }else{
            //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    //tableView点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
            switch(indexPath.section){
            case 1:
                if indexPath.row == 0{
                }else if indexPath.row == 1{
                    let reachability = Reachability.reachabilityForInternetConnection()
                    if reachability!.isReachable(){
                        let ChangePassVC = ChangePaswordController()
                        //ChangePassVC.currentPassword = self.currentUser.password
                        ChangePassVC.delegate = self
                        ChangePassVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(ChangePassVC, animated: true)
                    }else{
                        let alert:UIAlertController = UIAlertController(title: "网络提示", message: "无可用网络，不可修改密码", preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction:UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            case 2:
                self.clearCache()
            case 3:
                let alert = UIAlertController(title: "", message: "天软玩头盔开发团队", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction:UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            case 4:
                let alert = UIAlertController(title: "提示", message: "确定退出用户？", preferredStyle: UIAlertControllerStyle.Alert)
                let confirmAction:UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (confirm) in
                    //从数据库中修改登录状态为false,并退出程序
                    exit(0)
                })
                let cancelAction:UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            default:
                break
            }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
        let alert = UIAlertController(title: "清除缓存", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertConirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (alertConfirm) in
            //点击确定时开始删除
            for file in files!{
                let path = cachePath.stringByAppendingFormat("/\(file)")
                if NSFileManager.defaultManager().fileExistsAtPath(path){
                    try! NSFileManager.defaultManager().removeItemAtPath(path)
                }
            }
        }
        alert.addAction(alertConirm)
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (no) in
        }
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true) {}
    }
    
    
    //nickName点击手势
    func onNickNameClicked(tapGesture:UITapGestureRecognizer){
            let changeNickNameVC = ChangeNickNameController()
            changeNickNameVC.currentNickName = self.currentUser.nickName
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
