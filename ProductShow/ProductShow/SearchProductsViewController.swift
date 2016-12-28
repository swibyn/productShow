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
        tableView.register(nib, forCellReuseIdentifier: "productCell")
        
        self.cartBarButton.title = Cart.defaultCart().title
        self.addProductsInCartChangedNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    override func handleProductsInCartChangedNotification(_ paramNotification: Notification) {
        super.handleProductsInCartChangedNotification(paramNotification)
        self.cartBarButton.title = Cart.defaultCart().title
    }
    
    //MARK: function
    func SearchText(_ text: String){
        
        let searchText = text
        WebApi.SelectProByValue([jfquery : searchText], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                self.products.returnDic = json
                self.tableView.reloadData()
                
                if self.products.status == 1{
                    //获取成功
//                    self.tableView.reloadData()
                }else{
                    let msgString = json.object(forKey: jfmessage) as! String
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let searchText = searchTextField.text!
        SearchText(searchText)
        return true
    }
    
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        debugPrint("\(self) \(__FUNCTION__)  indexPath=\(indexPath)")
        let selectCell = tableView.cellForRow(at: indexPath) as? UIProductTableViewCell
        let detailVc = selectCell?.productViewController()
        detailVc?.product = selectCell?.product
        self.navigationController?.pushViewController(detailVc!, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return products.productsCount
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! UIProductTableViewCell
        
        // Configure the cell...
        
        ConfigureCell(cell, canAddToCart:true, product: products.productAtIndex(indexPath.row)!, delegate: self)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(UIProductTableViewCell.rowHeight)
    }
    
    
    //MARK: - UIProductTableViewCellDelegate
    func productTableViewCellButtonDidClick(_ cell: UIProductTableViewCell) {
        Cart.defaultCart().addProduct(cell.product)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kProductsInCartChanged), object: self)
    }
    //MARK: 

}

