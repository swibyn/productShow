//
//  CatagoriesTableViewController.swift
//  test
//
//  Created by s on 15/8/21.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var dataArray: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Categories"
//        self.tabBarItem.title = "产品类目"
        self.addFirstPageButton()
        
        WebApi.GetProLeave1(nil, completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
//                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                
                let statusInt = json.objectForKey(jfstatus) as! Int
                if (statusInt == 1){
                    //获取成功
                    let data = json.objectForKey(jfdata) as! NSDictionary
                    let dt = data.objectForKey(jfdt) as! NSArray
                    
                    self.dataArray = dt
                    self.tableView.reloadData()
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "Fail", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
                
                
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        categories = getCategoriesArray()        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
//        return categories.count
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        let dic = categories[section] as! NSDictionary
//        let items = dic.valueForKey("items") as! NSArray
//        return items.count
        return dataArray?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 

        // Configure the cell...
      
//        let dic = categories[indexPath.section] as! NSDictionary
//        let items = dic.valueForKey("items") as! NSArray
//        let dicItem = items[indexPath.row] as! NSDictionary
//        let value = dicItem.valueForKey("name") as! String
//        
//        cell.textLabel?.text = "\(indexPath.row + 1). \(value)"
//
//        return cell
        let dic = dataArray?[indexPath.row] as! NSDictionary
        let name = dic.valueForKey(jfcatName) as! String
        cell.textLabel?.text = "\(name)"
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
 
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let dic = categories[section] as! NSDictionary
//        let name = dic.valueForKey("name") as? String
//        return "\(section + 1). \(name)"
//    }
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.tableView.indexPathForSelectedRow!
        let destVC: AnyObject = segue.destinationViewController
        let dic = self.dataArray?[selectedIndexPath.row] as! NSDictionary
        let catId = dic[jfcatId] as! Int
        let catName = dic[jfcatName] as! String
        destVC.setValue(catId, forKey: "catId")
        destVC.setValue(catName, forKey: "catName")
    }
    

}
