
//
//  CategoryViewController.swift
//  Tutorial-MapKitSwift
//
//  Created by Cubo, Emilio on 17/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var persiana: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var cellSelected : Int = 0
    
    var categoryImages = [UIImage(named: "catRestaurant"),UIImage(named: "catToys"),UIImage(named: "catElectronic"),UIImage(named: "catClothes"),UIImage(named: "catSports"),UIImage(named: "catTravel"),UIImage(named: "catBaby"),UIImage(named: "catCare"),UIImage(named: "catFood")];
    var categoryName = [NSLocalizedString("Restaurant", comment: "Restaurant"),NSLocalizedString("Toys", comment: "Toys"),NSLocalizedString("Electronic", comment: "Electronic"),NSLocalizedString("Clothes", comment: "Clothes"),NSLocalizedString("Sports", comment: "Sports"),NSLocalizedString("Travel", comment: "Travel"),NSLocalizedString("Baby", comment: "Baby"),NSLocalizedString("Drugstore", comment: "Drugstore"),NSLocalizedString("Food", comment: "Food")];

    override func viewDidLoad() {
        super.viewDidLoad()

        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);

        collectionView.delegate = self;
        collectionView.dataSource = self;

        // MARK: - Escalar imagen estante
        myImage = UIImage(named: "estanteCategorias");
        rect = CGSizeMake(UIScreen.mainScreen().bounds.width, 115)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        collectionView.backgroundColor = UIColor(patternImage: newImage);

    }

    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        // Configure the cell
        cell.imageCell.image = categoryImages[indexPath.row];
        cell.textCategory.text = categoryName[indexPath.row].uppercaseString;
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        cellSelected = indexPath.row
        return true
    }
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "subcategories" {
            var subCategory = segue.destinationViewController as! SubCategoryViewController;
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            
            subCategory.currentCategory = cellSelected;
            subCategory.isLoading = false;
            subCategory.title = categoryName[cellSelected].uppercaseString;
            
        }
    }


}
