//
//  PersonalCenterViewController.swift
//  MySqliteConnect
//
//  Created by tjise on 16/5/27.
//  Copyright © 2016年 tjise. All rights reserved.
//



import UIKit

class PersonalCenterController: UIViewController , UIActionSheetDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{
    
    var mainTableView:UITableView!
    var imageView = UIImageView()
    var dataArrs:[[String]] = [[String]]()
    var nicknameText:UILabel!
    
    
    
    //服务器下载头像代码函数,此方法返回image，同时将图片存储到本地。
    // self.loadAvatarImg()->UIImage;
    
    //获取本地存储图像的方法如下
    //let documentPath:String = NSHomeDirectory() as String
    //self.imagePath = documentPath.stringByAppendingFormat("/Documents/\(UserInfo.phoneNumber.md5).jpg")
    //存储路径为：NSHomeDirectory/Documents/phoneNumber.md5.jpg
    
    
    //由于同一时间内存中只有一个User，所以删除User模型，使用全局常量UserInfo存储当前用户信息，用户中心只用到nickname和phoneNumber。头像使用UserInfo.phoneNumber.md5作为文件名，从服务器获得并存入资源文件夹。
    //请设置AutoLyout，简单使用self.view.size设置相应的frame即可。有问题请直接找我。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化数据
        
        self.title = "个人中心"
//        UserInfo.nickname = "1"
//        UserInfo.phoneNumber = "1"
//        UserInfo.UID = "1"
        initDataArrs()
        self.setTableView()
        //添加头像
        self.setAvaterImage()
        self.setNicknameText()
        //判断联网成功，则从服务器读取头像
        let reachability = Reachability.reachabilityForInternetConnection()
        if reachability!.isReachable(){
            PersonalCenterController.loadAvatarImg()
        }
        //添加返回按钮
        self.addLeftButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.nicknameText.text = UserInfo.nickname == "" ? UserInfo.phoneNumber : UserInfo.nickname
        if UserInfo.avatar == nil{
            UserInfo.avatar = UIImage(named: "默认头像小")
        }
        self.imageView.image = UserInfo.avatar
    }
    
    //添加tableView
    func setTableView(){
        let tableViewFrame:CGRect = CGRectMake(8, 0, self.view.bounds.width-16, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.mainTableView.scrollEnabled = true
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
        //添加图像手势
        let imageClickGesture = UITapGestureRecognizer(target: self, action: "changeAvaterImage:")
        self.imageView.addGestureRecognizer(imageClickGesture)
    }
    
    //设置昵称
    func setNicknameText(){
        let textFrame:CGRect = CGRectMake(120, 0, 450, 100)
        self.nicknameText = UILabel(frame: textFrame)
        self.nicknameText.userInteractionEnabled = true
       // self.nicknameText.userInteractionEnabled = UserInfo.phoneNumber != "Visitor"
//        let tapGesture = UITapGestureRecognizer(target: self, action: "onNicknameClicked:")
//        self.nicknameText.addGestureRecognizer(tapGesture)
    }
    
    //修改头像
    func changeAvaterImage(gesture:UITapGestureRecognizer){
        let actionSheet = UIActionSheet(title: "图片来源", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从相册选择","使用相机拍摄")
        actionSheet.tag  = 1000
        actionSheet.showInView(self.view)
    }
    
    //打开相册或相机
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.tag == 1000{
            var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            switch(buttonIndex){
            case 1:
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
        let Orginmage = info[UIImagePickerControllerEditedImage] as! UIImage
        let image = Orginmage.fixOrientation()
        //此处调用上传，失败则提示用户修改头像失败
        //如上传成功，将头像保存至本地资源文件夹，名称为UserInfo.phoneNumber.md5
        let scale = image.size.width > image.size.height ? image.size.height/160 : image.size.width/160
        let tempImg = UIImage(CGImage: image.CGImage!, scale: scale, orientation: .Up)
        let resizeImg = tempImg.resizeImage(tempImg, newSize: CGSizeMake(160, 160))
        self.saveLocalImage(resizeImg)
        picker.dismissViewControllerAnimated(true) {        }
    }
    
    //保存图片到本地和服务器
    func saveLocalImage(tempImg:UIImage){
        let imageData = UIImageJPEGRepresentation(tempImg, 1)

        //上传至服务
        RequestAPI.UploadPicture("upload.php", body: nil, block: { (formData:AFMultipartFormData!) in
            formData.appendPartWithFileData(imageData!, name: "file", fileName: UserInfo.phoneNumber.md5, mimeType: "image/jpg")
            }, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject? ) in
                //保存至本地
                PersonalCenterController.loadAvatarImg()
                imageData?.writeToFile((NSHomeDirectory() as String).stringByAppendingFormat("/Documents/\(UserInfo.phoneNumber.md5).jpg"), atomically: true)
                UserInfo.avatar = UIImage(CGImage: tempImg.CGImage!, scale: 2, orientation: .Up)
                self.imageView.image = tempImg
            }) { (task:NSURLSessionDataTask?, error:NSError?) in
                //failure
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.label.text = "修改头像失败,请检查网络连接"
                hud.hideAnimated(true, afterDelay: 1)
        }

    }
    
    //从服务器下载头像
    static func loadAvatarImg()->Void{
        //load pitcure
        let loadedData = NSData(contentsOfURL: NSURL(string: "\(RequestClient.URL)/uploadimg/\(UserInfo.phoneNumber.md5).jpg")!)
        //存储到本地
        loadedData?.writeToFile((NSHomeDirectory() as String).stringByAppendingFormat("/Documents/\(UserInfo.phoneNumber.md5).jpg"), atomically: true)
        
        print("路径为：\((NSHomeDirectory() as String))/Documents")
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
        return ""
    }
    
    //设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return 100
        }else if indexPath.section == 1 && indexPath.row == 1 && UserInfo.phoneNumber == "Visitor"{
            return 0
        }
        else if indexPath.section == 4 && indexPath.row == 0 && UserInfo.phoneNumber == "Visitor"{
            return 0
        }else if indexPath.section == 1 && indexPath.row == 0 && UserInfo.phoneNumber == "Visitor"{
            return 0
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
        if UserInfo.phoneNumber != "Visitor"{
            let frame:CGRect = CGRectMake(20, 20, 20, 42)
            var cell = UITableViewCell(frame:frame)
            let sectionArr = dataArrs[indexPath.section]
            cell.textLabel?.text = sectionArr[indexPath.row]
            var font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            if indexPath.section == 1 && indexPath.row == 0{
                let frame:CGRect = CGRectMake(self.view.bounds.size.width - 180, 0, 140, 42)
                let phoneNumberText = UILabel(frame: frame)
                phoneNumberText.text = UserInfo.phoneNumber
                phoneNumberText.textAlignment = .Right
                phoneNumberText.font = font
                cell.addSubview(phoneNumberText)
//                cell.separatorStyle = .SingleLine
            }
            else if indexPath.section == 4 && indexPath.row == 0{
                font = UIFont(name: "HelveticaNeue", size: 16.0)
                cell.backgroundColor = .redColor()
                cell.textLabel?.textColor = .whiteColor()
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
                    let tapGesture = UITapGestureRecognizer(target: self, action: "onNicknameClicked:")
                    self.nicknameText.addGestureRecognizer(tapGesture)
                    cell.addSubview(nicknameText)
                    nicknameText.font = font
                    cell.selectionStyle = .None
                }
                cell.addSubview(detailImageView)
            }
            cell.textLabel!.font = font
            cell.layer.cornerRadius = 3
            cell.selectionStyle = .None
            return cell
        }else{
            let frame:CGRect = CGRectMake(20, 20, 20, 42)
            var cell = UITableViewCell(frame:frame)
            let sectionArr = dataArrs[indexPath.section]
            cell.textLabel?.text = sectionArr[indexPath.row]
            let font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            if indexPath.section == 1 && indexPath.row == 0{
                let frame:CGRect = CGRectMake(self.view.bounds.size.width - 180, 0, 140, 42)
                let phoneNumberText = UILabel(frame: frame)
                phoneNumberText.text = UserInfo.phoneNumber
                phoneNumberText.textAlignment = .Right
                phoneNumberText.font = font
                cell.addSubview(phoneNumberText)
                if UserInfo.phoneNumber == "Visitor"{
                    phoneNumberText.text = ""
                    cell.textLabel?.text = ""
                }
            }else if indexPath.section == 1 && indexPath.row == 1{
                cell.textLabel?.text = ""
            }
            else{
                let detailImageView = UIImageView(image: UIImage(named: "右箭头"))
                detailImageView.frame = CGRectMake(self.view.bounds.size.width - 40, (cell.frame.minY + cell.frame.maxY) / 2 - 6, 12, 12)
                if indexPath.section == 0 && indexPath.row == 0{
                    let frame:CGRect = CGRectMake(20, 0, 200, 200)
                    cell = UITableViewCell(frame: frame)
                    detailImageView.frame = CGRectMake(self.view.bounds.size.width - 40, 44, 12, 12)
                    cell.addSubview(imageView)
                        //设置跳到登录界面按钮
                    self.nicknameText.text = "登录/注册"
                    let tapGesture = UITapGestureRecognizer(target: self, action: "onLoginClicked:")
                    self.nicknameText.addGestureRecognizer(tapGesture)
                    cell.addSubview(nicknameText)
                    nicknameText.font = font
                    cell.selectionStyle = .None
                }
                cell.addSubview(detailImageView)
            }
            cell.textLabel!.font = font
            cell.layer.cornerRadius = 3
            cell.selectionStyle = .None
            return cell
        }
    }
    
    //tableView点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        switch(indexPath.section){
        case 1:
            if indexPath.row == 0{
            }else if indexPath.row == 1 && UserInfo.phoneNumber != "Visitor"{
                let reachability = Reachability.reachabilityForInternetConnection()
                if reachability!.isReachable(){
                    let ChangePassVC = ChangePaswordController()
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
            let AboutVc = AboutViewController()
            self.navigationController?.pushViewController(AboutVc, animated: true)
        case 4:
            if UserInfo.phoneNumber == "Visitor"{
                UserInfo = UserInfoStruct()
                self.presentViewController(PhoneNumberViewController(), animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "提示", message: "确定注销？", preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: "确定", style: .Default, handler: { (confirm) in
                    if DatabaseService.sharedInstance.updateLoginState(0){
                        UserInfo = UserInfoStruct()
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
    
    
    //统计缓存大小
    func fileSizeOfCache()-> Int {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        //缓存目录路径
        print(cachePath)
        if NSFileManager.defaultManager().fileExistsAtPath(cachePath!){
            // 取出文件夹下所有文件数组
            let fileArr = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
            //快速枚举出所有文件名 计算文件大小
            var size = 0
            for file in fileArr! {
                // 把文件名拼接到路径中
                let path = cachePath?.stringByAppendingString("/\(file)")
                // 取出文件属性
                let floder = try! NSFileManager.defaultManager().attributesOfItemAtPath(path!)
                // 用元组取出文件大小属性
                for (abc, bcd) in floder {
                    // 累加文件大小
                    if abc == NSFileSize {
                        size += bcd.integerValue
                    }
                }
            }
            let mm = size / 1024
            return mm
        }else{
            return 0
        }
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,NSSearchPathDomainMask.UserDomainMask, true).first
            if NSFileManager.defaultManager().fileExistsAtPath(cachePath!){
                // 取出文件夹下所有文件数组
                let fileArr = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
                // 遍历删除
                for file in fileArr! {
                    let path = cachePath?.stringByAppendingString("/\(file)")
                    if NSFileManager.defaultManager().fileExistsAtPath(path!) {
                        do {
                            try NSFileManager.defaultManager().removeItemAtPath(path!)
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
    //清理缓存
    func clearCache() {
        let frame = CGRectMake(self.view.bounds.size.width/2-5, self.view.bounds.size.height/2-50, 10, 10)
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView(frame: frame)
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.color = UIColor.grayColor()
        indicator.hidesWhenStopped = true
       // self.view.addSubview(indicator)
        indicator.startAnimating()
        let size = self.fileSizeOfCache()
        var message = "\(size)K缓存"
        if size > 1024{
            message = "\(size/1024)M缓存"
        }
        print(message)
        
        let alert = UIAlertView(title: "清理缓存", message: message, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
//        let alert = UIAlertController(title: "清理缓存", message: message, preferredStyle: .Alert)
//        let alertConirm = UIAlertAction(title: "确定", style: .Default) { (alertConfirm) in
//           // indicator.stopAnimating()
//            // 取出cache文件夹目录 缓存文件都在这个目录下
//            let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
//            if NSFileManager.defaultManager().fileExistsAtPath(cachePath!){
//                // 取出文件夹下所有文件数组
//                let fileArr = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
//                // 遍历删除
//                for file in fileArr! {
//                    let path = cachePath?.stringByAppendingString("/\(file)")
//                    if NSFileManager.defaultManager().fileExistsAtPath(path!) {
//                        do {
//                            try NSFileManager.defaultManager().removeItemAtPath(path!)
//                        } catch {
//                        }
//                    }
//                }
//            }
//        }
//        alert.addAction(alertConirm)
//        let cancel = UIAlertAction(title: "取消", style: .Cancel) { (no) in
//            //indicator.stopAnimating()
//        }
//        alert.addAction(cancel)
//        self.mainTableView.beginUpdates()
//        self.presentViewController(alert, animated: true) { 
//            indicator.stopAnimating()
//        }
//        self.mainTableView.endUpdates()
    }
    
    //nickname点击手势
    func onNicknameClicked(tapGesture:UITapGestureRecognizer){
        self.navigationController?.pushViewController(ChangeNicknameController(), animated: true)
    }
    
    func onLoginClicked(gesture:UITapGestureRecognizer){
        self.presentViewController(LogInViewController(), animated: true, completion: nil)
    }
}
