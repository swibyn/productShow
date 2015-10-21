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
        self.title = "Product Detail"
    }
    
    //MARK: Table view delegate
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
//        let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
//        cell1.textLabel?.text = "\(indexPath)"
//        return cell1
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell\(indexPath.row)", forIndexPath: indexPath)
        
        // Configure the cell...
        switch indexPath.row{
        case 0:
            let productImageView = cell.viewWithTag(100) as! UIImageView
            let namelabel = cell.viewWithTag(101) as! UILabel
            let sizelabel = cell.viewWithTag(102) as! UILabel
            let remarkTextView = cell.viewWithTag(103) as! UITextView
            
            WebApi.GetFile(product?.imgUrl, completedHandler: { (response, data, error) -> Void in
                if data?.length > 0{
                productImageView.image = UIImage(data:data!)
                }
            })
            namelabel.text = "Name: \((product?.proName)!)"
            sizelabel.text = "Size: \((product?.proSize)!)"
            remarkTextView.text = product?.remark
            
//            cell.textLabel?.text = "Name: \((product?.proName)!)"
        case 1:
            cell.textLabel?.text = "Size: \((product?.proSize)!)"
        case 2:
            let textView = cell.viewWithTag(100) as! UITextView
            textView.text = product?.remark// productDic?.objectForKey(jfremark) as? String
//        case 3: //产品详情
//            ;
//        case 4: //
//            cell.textLabel?.text =
        default: break
            //nothing
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? CGFloat(310) : CGFloat(44)
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
