//
//  SecondViewController.swift
//  test
//
//  Created by s on 15/8/21.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

import UIKit

class SearchProductsViewController: UITableViewController, UISearchBarDelegate, UIProductTableViewCellDelegate, UITextFieldDelegate{
    
    var products = Products()

    @IBOutlet var cartBarButton: UIBarButtonItem!
//    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.addFirstPageButton()
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        
        self.cartBarButton.title = Cart.defaultCart().title
        self.addProductsInCartChangedNotificationObserver()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeProductsInCartChangedNotificationObserver()
    }
    
    //MARK: 消息通知
    override func handleProductsInCartChangedNotification(paramNotification: NSNotification) {
        super.handleProductsInCartChangedNotification(paramNotification)
        self.cartBarButton.title = Cart.defaultCart().title
    }
    
    //MARK: function
    func SearchText(text: String){
        
        let searchText = text
        WebApi.SelectProByValue([jfquery : searchText], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                self.products.returnDic = json
                self.tableView.reloadData()
                
                if self.products.status == 1{
                    //获取成功
//                    self.tableView.reloadData()
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }else{
                let alertView = UIAlertView(title: nil, message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        })
    }
 
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let searchText = searchTextField.text!
        SearchText(searchText)
        return true
    }
    
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        debugPrint("\(self) \(__FUNCTION__)  indexPath=\(indexPath)")
        let selectCell = tableView.cellForRowAtIndexPath(indexPath) as? UIProductTableViewCell
        let detailVc = selectCell?.productViewController()
        detailVc?.product = selectCell?.product
        self.navigationController?.pushViewController(detailVc!, animated: true)
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
        
        return products.productsCount
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! UIProductTableViewCell
        
        // Configure the cell...
        
        ConfigureCell(cell, canAddToCart:true, product: products.productAtIndex(indexPath.row)!, delegate: self)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(UIProductTableViewCell.rowHeight)
    }
    
    
    //MARK: - UIProductTableViewCellDelegate
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell) {
        Cart.defaultCart().addProduct(cell.product.productDic!)
        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
    }
    //MARK: 

}

