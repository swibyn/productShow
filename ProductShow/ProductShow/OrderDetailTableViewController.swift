//
//  OrderTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/16.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit



class OrderDetailTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIProductTableViewCellDelegate {
    
    var order: Order! //可修改内容，不要重新赋值，不然保存不了订单
    
    //MARK: IBAction
    @IBAction func addPictureButtonAction(sender: UIBarButtonItem) {
        
        let isAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("从照片库中读取")
        if isAvailable {
            actionSheet.addButtonWithTitle("拍一张")
        }
        
        actionSheet.showInView(self.tableView)

    }
    
    @IBAction func submitButtonAction(sender: UIBarButtonItem) {
        placeOrder()
        
    }
    
    //MARK: view lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 提交订单
    let alertView = UIAlertView(title: "图片提交中...", message: nil, delegate: nil, cancelButtonTitle: nil)
    
    func placeOrder(){
        let imagePathDicOpt = order.firstImageToBeUpload()
        if let imagePathDic = imagePathDicOpt{
            //有图片需要提交
            let localPath = imagePathDic.objectForKey(OrderSaveKey.localpath) as! String
            let image = PhotoUtil.getPhoto(localPath)
            alertView.message = localPath
            alertView.show()
            WebApi.UpFile(image!, completedHandler: { (response, data, error) -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error)
                {
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                    let remoteUrl = json.objectForKey(jfurl) as! String
                    Order.setRemotePath(remoteUrl, toDic: imagePathDic)
                    self.performSelector(Selector("placeOrder"), withObject: nil, afterDelay: 1)
                }
            })
        }else{
            //图片已提交完毕，提交文本订单
            sendShopData()
        }
        
    }
    
    func sendShopData(){
        
        //设备编号
        let eqNo = (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
        
        //用户信息
        let uname = UserInfo.defaultUserInfo().infoForKey(jfuname)!
        let uid = UserInfo.defaultUserInfo().uid!
        
        //图片
        let imgPaths = order.remotePathsDivideBy("|")
        
        alertView.message = "订单提交中..."
        WebApi.SendShopData([jfeqNo : eqNo, jfuid : uid,  "uName" : uname, jfproIds : order.proIds, jfimgPaths : imgPaths],
            completedHandler: { (response, data, error) -> Void in
                self.alertView.dismissWithClickedButtonIndex(-1, animated: false)//隐藏弹出的提示
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                    
                    let statusInt = json.objectForKey(jfstatus) as! Int
                    if (statusInt == 1){
                        //提交成功
                        let alertView = UIAlertView(title: "提交成功", message: "订单提交成功", delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                        OrderManager.defaultManager().removeOrder(self.order)
                    }else{
                        let msgString = json.objectForKey(jfmessage) as! String
                        let alertView = UIAlertView(title: "提交失败", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                }else{
                    let alertView = UIAlertView(title: "提交失败", message: "请求失败", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
        })
    }
    
    //MARK: camera
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {//保存图片
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if picker.sourceType == UIImagePickerControllerSourceType.Camera{
            UIImageWriteToSavedPhotosAlbum(image!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        }
        
        let filename = PhotoUtil.savePhoto(image, forName: nil)
        order.addImagePath(filename!)
        self.tableView.reloadData()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            UIAlertView(title: "提示", message: "图片保存失败", delegate: nil, cancelButtonTitle: "好的").show()
        }else{
            
            UIAlertView(title: "提示", message: "图片已保存到照片库", delegate: nil, cancelButtonTitle: "好的").show()
        }
    }
    
    
    //MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        
        debugPrint("actionSheet buttonindex=\(buttonIndex)")
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if buttonIndex == 1{
            imagePicker.sourceType = .PhotoLibrary
        }else if buttonIndex == 2{
            imagePicker.sourceType = .Camera
        }else{
            return
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return order.products.count + (order.imagePaths?.count ?? 0)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let products = order.products // orderDic?.objectForKey(OrderSaveKey.products) as! NSArray
        let imgPahts = order.imagePaths // orderDic?.objectForKey(OrderSaveKey.imagePaths) as! NSArray
        
        if indexPath.row < products.count{ //显示产品
            let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! UIProductTableViewCell
            
            let dic = products.objectAtIndex(indexPath.row) as! NSDictionary
            
            ConfigureCell(cell, buttonTitle: "", productDic: dic, delegate: nil)
            //ConfigureCell(cell, buttonTitle: "Delete", productDic: dic, delegate: self)
            
            return cell
            
        }else{ //显示图片
            let cell = tableView.dequeueReusableCellWithIdentifier("imagecell", forIndexPath: indexPath)
            
            let imgIndex = indexPath.row - products.count
            let imageView = cell.viewWithTag(100) as! UIImageView
            let image = PhotoUtil.getPhoto((imgPahts!.objectAtIndex(imgIndex) as! NSDictionary).objectForKey(OrderSaveKey.localpath) as! String)
            imageView.image = image
            return cell
            
        }
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let products = order.products // orderDic?.objectForKey(OrderSaveKey.products) as! NSArray
//        let imgPahts = order.imagePaths // orderDic?.objectForKey(OrderSaveKey.imagePaths) as! NSArray
        if indexPath.row < products.count{
        return CGFloat(UIProductTableViewCell.rowHeight)
        }else{
            return self.tableView.rowHeight
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: UIProductTableViewCellDelegate
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell) {
//        Order(orderdictionary: self.orderDic).
//        Global.cart.removeProduct(cell.productDic)
//        NSNotificationCenter.defaultCenter().postNotificationName(kOrdersChanged, object: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}