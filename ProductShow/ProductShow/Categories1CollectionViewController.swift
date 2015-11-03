//
//  Categories1CollectionViewController.swift
//  ProductShow
//
//  Created by s on 15/10/27.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

let categoryColors:[[CGFloat]] = [[6,181,122],[90,190,40],[252,169,13],[110,128,240],[39,197,244],[251,121,46],[62,132,254]]

func categoryColor(row: Int)->UIColor{
    let _color = categoryColors[row % categoryColors.count]
    let color = UIColor(red: _color[0]/255, green: _color[1]/255, blue: _color[2]/255, alpha: 1)
    return color
}
//let mycolor = [UIColor.greenColor(),UIColor.blueColor(),UIColor.redColor(),UIColor.orangeColor(),UIColor.yellowColor(),UIColor.cyanColor(),UIColor.magentaColor(),UIColor.purpleColor(),UIColor.brownColor()]

class Categories1CollectionViewController: UICollectionViewController {
    
//    var dataArray: NSArray?
    var categories: Categories?
    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(self) \(__FUNCTION__)")
        
        self.title = "Product Categories"
        self.addFirstPageButton()
        
        GetProLeave1()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: function
    func GetProLeave1(){
        
        WebApi.GetProLeave1(nil, completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                self.categories = Categories(returnDic: json)
                
                if (self.categories!.status! == 1){
                    
                    self.collectionView?.reloadData()
                }else{
                    
                    let msgString = self.categories?.message
                    let alertView = UIAlertView(title: "Fail", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }
    
    
    //MARK: UICollectionViewController Data source
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories?.categoriesCount ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let label = cell.viewWithTag(100) as? UILabel
    
        label?.backgroundColor = categoryColor(indexPath.row)
        
        let catname = categories?.categoryAtIndex(indexPath.row)?.catName
        label?.text =  "\(catname!)"
        
        return cell
    }
    
    func color(old: Int, row: Int, step: Int)->CGFloat{
        return CGFloat(((old + row * step) % 255 + 255) % 255)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let size = self.collectionView?.bounds.size
//            let width = self.collectionView?.bounds
            return  CGSize(width: (size!.width - 60)/2 ,height: 97)
            
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell)
        let destVC: AnyObject = segue.destinationViewController
        let index = selectedIndexPath?.row
        destVC.setValue(self.categories?.categoryAtIndex(index!), forKey: "category1")
    }
    
}



















