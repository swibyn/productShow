//
//  CatagoriesTableViewController.swift
//  test
//
//  Created by s on 15/8/21.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

import UIKit

class CategoriesTableViewController: TabTableViewControllerBase {
    
    var categories: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "产品类目"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        categories = getCategoriesArray()        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func getCategoriesArray()->NSArray{
        var error1:NSErrorPointer = nil;
        //let filepath:String? = "category.txt"
        let filepath = NSBundle.mainBundle().pathForResource("category", ofType: "txt")
//        println("filepath=\(filepath)")
        let data = NSData(contentsOfURL: NSURL(fileURLWithPath: filepath!)!)
//        println("data=\(data)")
        let jsonobj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: error1)
//        println("json=\(jsonobj)")
        return jsonobj! as! NSArray
        
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
        return categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
      
//        let dic = categories[indexPath.section] as! NSDictionary
//        let items = dic.valueForKey("items") as! NSArray
//        let dicItem = items[indexPath.row] as! NSDictionary
//        let value = dicItem.valueForKey("name") as! String
//        
//        cell.textLabel?.text = "\(indexPath.row + 1). \(value)"
//
//        return cell
        let dic = categories[indexPath.row] as! NSDictionary
        let name = dic.valueForKey("name") as! String
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
        let selectedIndexPath = self.tableView.indexPathForSelectedRow()!
        let destVC: AnyObject = segue.destinationViewController
        let dic = categories[selectedIndexPath.row] as! NSDictionary
        let dataArray = NSArray(object: dic)
        destVC.setValue(dataArray, forKey: "dataArray")
    }
    

}
