//
//  Categories1CollectionViewController.swift
//  ProductShow
//
//  Created by s on 15/10/27.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

let categoryColors:[[CGFloat]] = [[6,181,122],[90,190,40],[252,169,13],[110,128,240],[39,197,244],[251,121,46],[62,132,254]]

func categoryColor(_ row: Int)->UIColor{
    let _color = categoryColors[row % categoryColors.count]
    let color = UIColor(red: _color[0]/255, green: _color[1]/255, blue: _color[2]/255, alpha: 1)
    return color
}

class Categories1CollectionViewController: UICollectionViewController {
    
    var categories: Categories?
    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Product Categories"
        self.addFirstPageButton()
        
//        GetProLeave1()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if categories?.status != 1{
            GetProLeave1()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: function
    func GetProLeave1(){
        
        WebApi.GetProLeave1(nil, completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                self.categories = Categories(returnDic: json)
                self.collectionView?.reloadData()
                
                if (self.categories!.status! == 1){
                    
                }else{
                    
                    let msgString = self.categories?.message
                    let alertView = UIAlertView(title: nil, message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }
    
    
    //MARK: UICollectionViewController Data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories?.categoriesCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        let label = cell.viewWithTag(100) as? UILabel
    
        label?.backgroundColor = categoryColor(indexPath.row)
        
        let catname = categories?.categoryAtIndex(indexPath.row)?.catName
        label?.text =  "\(catname!)"
        
        return cell
    }
    
    func color(_ old: Int, row: Int, step: Int)->CGFloat{
        return CGFloat(((old + row * step) % 255 + 255) % 255)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
            let size = self.collectionView?.bounds.size
//            let width = self.collectionView?.bounds
            return  CGSize(width: (size!.width - 60)/2 ,height: 97)
            
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell)
        let destVC: AnyObject = segue.destination
        let index = selectedIndexPath?.row
        destVC.setValue(self.categories?.categoryAtIndex(index!), forKey: "category1")
    }
    
}



















