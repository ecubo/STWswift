
//
//  CategoryViewController.swift
//  Tutorial-MapKitSwift
//
//  Created by Cubo, Emilio on 17/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class ProductoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSXMLParserDelegate {
    
    @IBOutlet var persiana: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var fondoColor: UIView!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    var cellSelected : Int = 0

    
    var categoryColors = [
        UIColor(red: 0/255, green: 187/255, blue: 255/255, alpha: 1),
        UIColor(red: 255/255, green: 104/255, blue: 111/255, alpha: 1),
        UIColor(red: 255/255, green: 159/255, blue: 0/255, alpha: 1),
        UIColor(red: 176/255, green: 89/255, blue: 185/255, alpha: 1),
        UIColor(red: 255/255, green: 196/255, blue: 0/255, alpha: 1),
        UIColor(red: 59/255, green: 86/255, blue: 103/255, alpha: 1),
        UIColor(red: 0/255, green: 217/255, blue: 200/255, alpha: 1),
        UIColor(red: 0/255, green: 105/255, blue: 157/255, alpha: 1),
        UIColor(red: 180/255, green: 185/255, blue: 20/255, alpha: 1)];
    
    var bkColors = [
        UIColor(red: 0/255, green: 139/255, blue: 206/255, alpha: 1),
        UIColor(red: 245/255, green: 74/255, blue: 92/255, alpha: 1),
        UIColor(red: 250/255, green: 135/255, blue: 0/255, alpha: 1),
        UIColor(red: 157/255, green: 74/255, blue: 169/255, alpha: 1),
        UIColor(red: 252/255, green: 175/255, blue: 0/255, alpha: 1),
        UIColor(red: 47/255, green: 77/255, blue: 94/255, alpha: 1),
        UIColor(red: 0/255, green: 179/255, blue: 177/255, alpha: 1),
        UIColor(red: 0/255, green: 80/255, blue: 129/255, alpha: 1),
        UIColor(red: 152/255, green: 157/255, blue: 0/255, alpha: 1)];
    
    var estantes = [
        UIImage(named: "estanteRestaurante"),
        UIImage(named: "estanteToys"),
        UIImage(named: "estanteElectronic"),
        UIImage(named: "estanteClothes"),
        UIImage(named: "estanteSports"),
        UIImage(named: "estanteTravel"),
        UIImage(named: "estanteBaby"),
        UIImage(named: "estanteDrugstore"),
        UIImage(named: "estanteFood")];
    
    var subcategorias = [1,2,5,3,4,9,8,6,7];
    
    var currentCategory:Int!;
    var currentSubcategory:Int!;
    var currentProducto:Producto = Producto();
    var listProductos:[Producto] = [];
    
    var txtNode:NSMutableString = NSMutableString();
    var parser:NSXMLParser = NSXMLParser();
    var isLoading:Bool = false;
    
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
        myImage = estantes[currentCategory];
        rect = CGSizeMake(UIScreen.mainScreen().bounds.width, 115)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        collectionView.backgroundColor = UIColor(patternImage: newImage);
        
        fondoColor.backgroundColor = bkColors[currentCategory];
        
        loading.hidden = false;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!isLoading) {
            let locale: NSLocale = NSLocale.currentLocale();
            let languageCode = locale.objectForKey(NSLocaleLanguageCode) as! String;
            parser = NSXMLParser(contentsOfURL: (NSURL(string: "http://shoptheworld.labstoreshopper.com/api/markers/api_stw.php?p=getProductos&subcategoria=\(currentSubcategory)&language=\(languageCode)")))!;
            parser.delegate=self;
            parser.parse();
            isLoading = true;
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return listProductos.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        // Configure the cell
        var producto = listProductos[indexPath.row];
        
        cell.backgroundColor = categoryColors[currentCategory];
        
//        let baseURLImages:String = "http://shoptheworld.labstoreshopper.com/api/markers/uploads/productosPNG/";
//        
//        let urlString:String = "\(baseURLImages)\(producto.id!).png";
//        let urlImage:NSURL = NSURL(string: urlString)!;
//        let urlData:NSData = NSData(contentsOfURL: urlImage)!;
//        
//        let request: NSURLRequest = NSURLRequest(URL: urlImage)
//        let mainQueue = NSOperationQueue.mainQueue()
//        
//        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
//            if error == nil {
//                // Convert the downloaded data in to a UIImage object
//                let image = UIImage(data: data)
//                // Update the cell
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    cell.imageCell.image = UIImage(data: urlData);
////                    cell.imageCell.image = cell.imageCell.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
////                    cell.imageCell.tintColor = UIColor.redColor();
//                })
//            }
//        })
        
        cell.imageCell.image = UIImage(named: producto.id!);
        
        cell.textCategory.text = producto.nombre?.uppercaseString;
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        cellSelected = indexPath.row
        return true
    }
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
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
    
    //MARK: - XML
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        txtNode = NSMutableString();
        if(elementName == "producto"){
            currentProducto = Producto();
        }
        
    }
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        txtNode.appendString(string!);
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch(elementName){
        case "id":
            currentProducto.id = txtNode as String!;
            break;
        case "nombre":
            currentProducto.nombre = txtNode as String!;
            break;
        case "tamagno":
            currentProducto.tamagno = txtNode as String!;
            break;
        case "color":
            currentProducto.color = txtNode as String!;
            break;
        case "producto":
            listProductos.append(currentProducto);
            break;
        default:
            collectionView.reloadData();
            loading.hidden = true;
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            
            break;
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailProducto" {
            var producto = segue.destinationViewController as! DetailProductoViewController;
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            
            producto.currentProduct = listProductos[cellSelected].id;
            producto.currentTalla = listProductos[cellSelected].tamagno;
            producto.currentColor = listProductos[cellSelected].color;
            producto.title = listProductos[cellSelected].nombre?.uppercaseString;

        }
    }

    
}
