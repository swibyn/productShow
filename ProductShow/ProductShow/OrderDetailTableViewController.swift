//
//  OrderTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/16.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol OrderDetailTableViewControllerDelegate{
    func OrderDetailTableViewDidPlaceOrder(_ detailController: OrderDetailTableViewController)
}

class OrderDetailTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIProductAndRemarkTableViewCellDelegate,UIAlertViewDelegate,UITextViewControllerDelegate {
    
    var order: Order! //可修改内容，不要重新赋值，不然保存不了订单,由调用者传过来
    fileprivate var bGoOnPlace = false
    
    var delegate: OrderDetailTableViewControllerDelegate?
    
    //MARK: 初始化一个实例
    static func newInstance()->OrderDetailTableViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailTableViewController") as! OrderDetailTableViewController
        return aInstance
    }
    
    //MARK: IB
    @IBOutlet var addPictureButton: UIBarButtonItem!
    @IBOutlet var submitButton: UIBarButtonItem!
    
    
    @IBAction func addPictureButtonAction(_ sender: UIBarButtonItem) {
        
        let isAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        actionSheet.addButton(withTitle: "From photo library")
        if isAvailable {
            actionSheet.addButton(withTitle: "Take a photo")
        }
        
        actionSheet.show(in: self.tableView)

    }
    
    @IBAction func submitButtonAction(_ sender: UIBarButtonItem) {
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
        tableView.register(nib, forCellReuseIdentifier: "ProductAndRemarkTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addOrdersChangedNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeOrdersChangedNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //处理消息通知
    override func handleOrdersChangedNotification(_ paramNotification: Notification) {
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
            let localPath = imagePathDic.object(forKey: OrderSaveKey.localpath) as! String
//            let imageData = PhotoUtil.getPhotoData(localPath)
            let alertView = UIAlertView(title: "photo uploading...", message: (localPath as NSString).lastPathComponent, delegate: self, cancelButtonTitle: "Cancel")
            alertView.show()
            WebApi.UpFile(localPath, completedHandler: { (response, data, error) -> Void in
                alertView.dismiss(withClickedButtonIndex: -1, animated: true)
                if WebApi.isHttpSucceed(response, data: data, error: error)
                {
                    let json = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                    let returnDic = ReturnDic(returnDic: json)
                    
                    if returnDic.status == 1{
                        let remoteUrl = json?.object(forKey: jfimgPath) as? String
                        Order.setRemotePath(remoteUrl!, toDic: imagePathDic)
                        self.perform(Selector("placeOrder"), with: nil, afterDelay: 1)
                    }else{
                        let msg = json?.object(forKey: jfmsg) as? String
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
        let eqNo = UIDevice.current.advertisingIdentifier.uuidString
        
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
                    
                    let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    let statusInt = json.object(forKey: jfstatus) as! Int
                    if (statusInt == 1){
                        //提交成功
                        //Orders.defaultOrders().removeOrder(self.order)
                        self.order.placed = true
                        self.postOrdersChangedNotification()
                        let alertView = UIAlertView(title: "Succeed", message: "Order placed", delegate: nil, cancelButtonTitle: "OK")
                        alertView.delegate = self
                        alertView.show()
                    }else{
                        let msgString = json.object(forKey: jfmessage) as! String
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
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {//保存图片
        
        picker.dismiss(animated: true, completion: nil)
        
        if picker.sourceType == UIImagePickerControllerSourceType.camera{
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(OrderDetailTableViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }

//        var saveImage: UIImage = image
//        if PhotoUtil.getMB(image)>2{
//            saveImage = PhotoUtil.ImageJPEGRepresentation(image, lessThenN: 2)
//        }
        let saveImageData = UIImageJPEGRepresentation(image, 0.5)
        let saveImage = UIImage(data: saveImageData!)
        
        let filename = PhotoUtil.savePhoto(saveImage!, forName: nil)
        order.addImageByPath(filename!)
//        postOrdersChangedNotification()
        self.tableView.reloadData()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
//        if error != nil {
//            UIAlertView(title: "Hint", message: "Photo save to library fail", delegate: nil, cancelButtonTitle: "OK").show()
//        }else{
//            
//            UIAlertView(title: "Hint", message: "Photo save to library succeed", delegate: nil, cancelButtonTitle: "OK").show()
//        }
    }
    //MARK: UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        let buttontitle = alertView.buttonTitle(at: buttonIndex)
        if buttontitle == "Cancel"{
            bGoOnPlace = false
            
        }else if ((alertView.message == "Order placed") && (buttontitle == "OK")){
            self.delegate?.OrderDetailTableViewDidPlaceOrder(self)
//            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button
    
    func alertViewCancel(_ alertView: UIAlertView){
        
    }
    
    //MARK: UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        if buttonIndex == 1{
            imagePicker.sourceType = .photoLibrary
        }else if buttonIndex == 2{
            imagePicker.sourceType = .camera
        }else{
            return
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }

    //MARK: UITextViewControllerDelegate
    func textViewControllerDone(_ textViewVC: UITextViewController) {
        let row = remarkCellIndexPath?.row
        let product = order.productAtIndex(row!)
        product?.additionInfo = textViewVC.textView.text
        Orders.defaultOrders().flush()
        self.navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return order.products.count + (order.imagePaths?.count ?? 0)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let products = order.products
//        let imgPaths = order.imagePaths
        
        if indexPath.row < products.count{ //显示产品
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAndRemarkTableViewCell", for: indexPath) as! UIProductAndRemarkTableViewCell
            
            ConfigureCell(cell, showRightButton:true, product: order.productAtIndex(indexPath.row)!, delegate: self)
            
            return cell
            
        }else{ //显示图片
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath)
            
            let imgIndex = indexPath.row - products.count
            let imageView = cell.viewWithTag(100) as! UIImageView
            let imagePath = order.imagePathAtIndex(imgIndex)
            let localpath = imagePath?.localpath
            let imageData = PhotoUtil.getPhotoData(localpath)
            if imageData?.count > 0{
                imageView.image = UIImage(data: imageData!)
            }
            
            return cell
            
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let products = order.products 
        if indexPath.row < products.count{
            let product = order.productAtIndex(indexPath.row)
            let height = UIProductAndRemarkTableViewCell.heightForProduct(tableView, product: product!)
            return height
            
        }else{
            return self.view.bounds.size.height
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    var remarkCellIndexPath: IndexPath?
    func productAndRemarkTableViewCellMemoButtonAction(_ cell: UIProductAndRemarkTableViewCell) {
        remarkCellIndexPath = self.tableView.indexPath(for: cell)
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
    
    func productAndRemarkTableViewCellQuantityDidChanged(_ cell: UIProductAndRemarkTableViewCell) {
        
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
