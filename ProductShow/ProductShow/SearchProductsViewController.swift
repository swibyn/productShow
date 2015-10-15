//
//  SecondViewController.swift
//  test
//
//  Created by s on 15/8/21.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

import UIKit

class SearchProductsViewController: TabTableViewControllerBase, UISearchBarDelegate {
    
    var dataArray: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "产品搜索"
        // Do any additional setup after loading the view, typically from a nib.
        
                
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) // called when keyboard search button pressed
    {
        searchBar.resignFirstResponder()
        let searchText = searchBar.text!
        WebApi.SelectPro([jfproName : searchText], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                
                let statusInt = json.objectForKey(jfstatus) as! Int
                if (statusInt == 1){
                    //获取成功
                    let data = json.objectForKey(jfdata) as! NSDictionary
                    let dt = data.objectForKey(jfdt) as! NSArray
                    
                    self.dataArray = dt
                    self.tableView.reloadData()
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "数据获取失败", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
        
    }
    
//    optional func searchBarBookmarkButtonClicked(searchBar: UISearchBar) // called when bookmark button pressed
    func searchBarCancelButtonClicked(searchBar: UISearchBar) // called when cancel button pressed
    {
        searchBar.resignFirstResponder()
        
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
        return dataArray?.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        // Configure the cell...
        let dic = dataArray?.objectAtIndex(indexPath.row) as! NSDictionary
        cell.textLabel?.text = dic.objectForKey(jfproName) as? String
        
        return cell
    }
    //MARK: 

}

