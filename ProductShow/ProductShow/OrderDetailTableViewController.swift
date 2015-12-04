//
//  OrderTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/16.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

protocol OrderDetailTableViewControllerDelegate{
    func OrderDetailTableViewDidPlaceOrder(detailController: OrderDetailTableViewController)
}

class OrderDetailTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIProductAndRemarkTableViewCellDelegate,UIAlertViewDelegate,UITextViewControllerDelegate {
    
    var order: Order! //可修改内容，不要重新赋值，不然保存不了订单,由调用者传过来
    private var bGoOnPlace = false
    
    var delegate: OrderDetailTableViewControllerDelegate?
    
    //MARK: 初始化一个实例
    static func newInstance()->OrderDetailTableViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OrderDetailTableViewController") as! OrderDetailTableViewController
        return aInstance
    }
    
    //MARK: IB
    @IBOutlet var addPictureButton: UIBarButtonItem!
    @IBOutlet var submitButton: UIBarButtonItem!
    
    
    @IBAction func addPictureButtonAction(sender: UIBarButtonItem) {
        
        let isAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("From photo library")
        if isAvailable {
            actionSheet.addButtonWithTitle("Take a photo")
        }
        
        actionSheet.showInView(self.tableView)

    }
    
    @IBAction func submitButtonAction(sender: UIBarButtonItem) {
        bGoOnPlace = true
        placeOrder()
        
    }
    
    //MARK: view lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = order.nameWithPlacedState
        if order.placed {
            submitButton.title = "SubmitAgain"
        }
        
        let nib = UINib(nibName: "ProductAndRemarkTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ProductAndRemarkTableViewCell")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addOrdersChangedNotificationObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeOrdersChangedNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //处理消息通知
    override func handleOrdersChangedNotification(paramNotification: NSNotification) {
        if !self.isEqual(paramNotification.object){
            self.tableView.reloadData()
        }
    }
    
    //MARK: 提交订单
    
    func placeOrder(){
        if !bGoOnPlace{
            return
        }
        
        let imagePathDicOpt = order.firstImageToBeUpload()
        if let imagePathDic = imagePathDicOpt{
            //有图片需要提交
            let localPath = imagePathDic.objectForKey(OrderSaveKey.localpath) as! String
            let imageData = PhotoUtil.getPhotoData(localPath)
            let alertView = UIAlertView(title: "photo uploading...", message: localPath, delegate: self, cancelButtonTitle: "Cancel")
            alertView.show()
            WebApi.UpFile1(imageData!, completedHandler: { (response, data, error) -> Void in
                alertView.dismissWithClickedButtonIndex(-1, animated: true)
                if WebApi.isHttpSucceed(response, data: data, error: error)
                {
                    let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                    let returnDic = ReturnDic(returnDic: json)
                    
                    if returnDic.status == 1{
                        let remoteUrl = json?.objectForKey(jfimgPath) as? String
                        Order.setRemotePath(remoteUrl!, toDic: imagePathDic)
                        self.performSelector(Selector("placeOrder"), withObject: nil, afterDelay: 1)
                    }else{
                        let msg = json?.objectForKey(jfmsg) as? String
                        let alertView = UIAlertView(title: "Fail", message: msg, delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                        
                    }
                }else{
                    let alertView = UIAlertView(title: nil, message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            })
        }else{
            //图片已提交完毕，提交文本订单
            sendShopData()
        }
        
    }
    
    func sendShopData(){
        
        //设备编号
        let eqNo = UIDevice.currentDevice().advertisingIdentifier.UUIDString
        
        //用户信息
        let uname = UserInfo.defaultUserInfo().firstUser?.uname
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        
        //图片
        let imgPaths = order.imgPathsForSubmit // order.remotePathsDivideBy("|")
        
//        let alertView = UIAlertView(title: "订单提交中...", message: nil, delegate: nil, cancelButtonTitle: "Cancel")
//        alertView.show()

        let products = order.productsForSubmit // order.proIdAndAdditions
        WebApi.SendShopData([jfeqNo : eqNo, jfuid : uid!,  jfuName : uname!, jfproducts : products, jfimgPaths : imgPaths],
            completedHandler: { (response, data, error) -> Void in
                
//                alertView.dismissWithClickedButtonIndex(-1, animated: false)//隐藏弹出的提示
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    let statusInt = json.objectForKey(jfstatus) as! Int
                    if (statusInt == 1){
                        //提交成功
                        //Orders.defaultOrders().removeOrder(self.order)
                        self.order.placed = true
                        self.postOrdersChangedNotification()
                        let alertView = UIAlertView(title: "Succeed", message: "Order placed", delegate: nil, cancelButtonTitle: "OK")
                        alertView.delegate = self
                        alertView.show()
                    }else{
                        let msgString = json.objectForKey(jfmessage) as! String
                        let alertView = UIAlertView(title: nil, message: msgString, delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                }else{
                    let alertView = UIAlertView(title: "Fail", message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
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

        var saveImage: UIImage = image
        if PhotoUtil.getMB(image)>2{
            saveImage = PhotoUtil.ImageJPEGRepresentation(image, lessThenN: 2)
        }
        
        let filename = PhotoUtil.savePhoto(saveImage, forName: nil)
        order.addImagePath(filename!)
        postOrdersChangedNotification()
        self.tableView.reloadData()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
//        if error != nil {
//            UIAlertView(title: "Hint", message: "Photo save to library fail", delegate: nil, cancelButtonTitle: "OK").show()
//        }else{
//            
//            UIAlertView(title: "Hint", message: "Photo save to library succeed", delegate: nil, cancelButtonTitle: "OK").show()
//        }
    }
    //MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let buttontitle = alertView.buttonTitleAtIndex(buttonIndex)
        if buttontitle == "Cancel"{
            bGoOnPlace = false
            
        }else if ((alertView.message == "Order placed") && (buttontitle == "OK")){
            self.delegate?.OrderDetailTableViewDidPlaceOrder(self)
//            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button
    
    func alertViewCancel(alertView: UIAlertView){
        
    }
    
    //MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        if buttonIndex == 1{
            imagePicker.sourceType = .PhotoLibrary
        }else if buttonIndex == 2{
            imagePicker.sourceType = .Camera
        }else{
            return
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    //MARK: UITextViewControllerDelegate
    func textViewControllerDone(textViewVC: UITextViewController) {
        let row = remarkCellIndexPath?.row
        let product = order.productAtIndex(row!)
        product?.additionInfo = textViewVC.textView.text
        Orders.defaultOrders().flush()
        self.navigationController?.popViewControllerAnimated(true)
        self.tableView.reloadData()
        
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
        let products = order.products
        let imgPahts = order.imagePaths
        
        if indexPath.row < products.count{ //显示产品
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductAndRemarkTableViewCell", forIndexPath: indexPath) as! UIProductAndRemarkTableViewCell
            
            ConfigureCell(cell, showRightButton:true, product: order.productAtIndex(indexPath.row)!, delegate: self)
            
            return cell
            
        }else{ //显示图片
            let cell = tableView.dequeueReusableCellWithIdentifier("imagecell", forIndexPath: indexPath)
            
            let imgIndex = indexPath.row - products.count
            let imageView = cell.viewWithTag(100) as! UIImageView
            let imageData = PhotoUtil.getPhotoData((imgPahts!.objectAtIndex(imgIndex) as! NSDictionary).objectForKey(OrderSaveKey.localpath) as! String)
            imageView.image = UIImage(data: imageData!)
            return cell
            
        }
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let products = order.products 
        if indexPath.row < products.count{
            let product = order.productAtIndex(indexPath.row)
            let height = UIProductAndRemarkTableViewCell.heightForProduct(tableView, product: product!)
            return height
            
        }else{
            return self.view.bounds.size.height
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let products = order.products
        if indexPath.row < products.count{ //点击查看产品详情
            let product = order.productAtIndex(indexPath.row)
            let detailVc = ProductViewController.newInstance()
            detailVc.product = product
            self.navigationController?.pushViewController(detailVc, animated: true)
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
    
    //MARK: UIProductAndRemarkTableViewCellDelegate
    var remarkCellIndexPath: NSIndexPath?
    func productAndRemarkTableViewCellButtonDidClick(cell: UIProductAndRemarkTableViewCell) {
        remarkCellIndexPath = self.tableView.indexPathForCell(cell)
        //添加备注
        let product = cell.product
        let textViewVC = UITextViewController.newInstance()
        textViewVC.delegate = self
        let additionInfo = product?.additionInfo
        let text = additionInfo ?? ""
        textViewVC.initTextViewText = text
        textViewVC.title = (product?.proName)!
  
        self.navigationController?.pushViewController(textViewVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.All
//    }
//    
//    override func shouldAutorotate() -> Bool {
//        return true
//    }

}
