//
//  FinalProductViewController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 14/7/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class FinalProductViewController: UIViewController {

    @IBOutlet var persiana: UIImageView!
    @IBOutlet var globo: UIImageView!
    @IBOutlet var imgProducto: UIImageView!
    @IBOutlet var sizeProducto: UILabel!
    @IBOutlet var nombreProducto: UILabel!
    
    var nombre:String!;
    var producto:String!;
    var talla:String!;
    var textColor:String!;
    var color:UIColor!;

    override func viewDidLoad() {
        super.viewDidLoad()

        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);
        
        imgProducto.image = UIImage(named: producto);
        imgProducto.image = imgProducto.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imgProducto.tintColor = color;
        
        nombreProducto.text = nombre.lowercaseString.capitalizedString;
        sizeProducto.text = talla;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
