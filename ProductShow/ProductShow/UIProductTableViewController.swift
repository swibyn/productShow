//
//  UIProductDetailTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/18.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UIProductTableViewController: UITableViewController {
    var product: Product?
//    var productDic: NSDictionary?
//    let listInfo = [jfproName]
    
    
    //MARK: 初始化一个实例
    static func newInstance()->UIProductTableViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UIProductTableViewController") as! UIProductTableViewController
        
    }
    
    //MARK: View life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Detail"
        
//        self.setBarButtonTint(UIColor.whiteColor())
        
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        let backBarButton = UIBarButtonItem(title: "bbbbb", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("didReceiveMemoryWarning"))
//        backBarButton.tintColor = UIColor.whiteColor()
//        self.navigationItem.backBarButtonItem = backBarButton
//        self.setBarButtonTint(UIColor.whiteColor())
//    }
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        //        self.setBarButtonTint(UIColor.whiteColor())
//    }
    //MARK: Events
    func addProductToCart(button:UIButton){
        Cart.defaultCart().addProduct(product!.productDic!)
        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
        let alertView = UIAlertView(title: "Hint", message: "Add to cart successfully", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        
    }
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint("\(self) \(__FUNCTION__)  indexPath=\(indexPath)")
        
    }
    
  
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell1 = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath)
//        cell1.textLabel?.text = "\(indexPath)"
//        return cell1
        
//        debugPrint("")
        let identifier = "cell\(indexPath.row)"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        // Configure the cell...
        switch indexPath.row{
        case 0:
            let productImageView = cell.viewWithTag(100) as? UIImageView
            let namelabel = cell.viewWithTag(101) as? UILabel
            let sizelabel = cell.viewWithTag(102) as? UILabel
            let remarkTextView = cell.viewWithTag(103) as? UITextView
            let button = cell.viewWithTag(104) as? UIButton
            
            WebApi.GetFile(product?.imgUrl, completedHandler: { (response, data, error) -> Void in
                if data?.length > 0{
                productImageView?.image = UIImage(data:data!)
                }
            })
            namelabel?.text = "Name: \((product?.proName)!)"
            sizelabel?.text = "Size: \((product?.proSize)!)"
        
            remarkTextView?.text = product?.remark
            button?.addTarget(self, action: "addProductToCart:", forControlEvents: UIControlEvents.TouchUpInside)

        default: break
            //nothing
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = tableView.rowHeight
        switch indexPath.row{
        case 0: height = 310
        case 3: height = 157
        default: break
        }
        
        return height
        
        
//        return (indexPath.row == 0) ? CGFloat(310) : CGFloat(44)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destVc = segue.destinationViewController
        destVc.setValue(product, forKey: "product")
        
    }

}
