//
//  DetailProductoViewController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 13/7/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class DetailProductoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var image: UIImageView!
    @IBOutlet var persiana: UIImageView!
    @IBOutlet var btnSize: UIButton!
    @IBOutlet var btnColor: UIButton!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var pickerColor: UIPickerView!

    var currentProduct:String!;
    var currentColor:String!;
    var currentTalla:String!;
    
    var tallaSeleccionada:String = "";
    var colorSeleccionado:UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1);
    var textColorSelecciondo:String = NSLocalizedString("White", comment: "White");
    
    var sizes = [];
    
    var colors = [
        UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        UIColor(red: 0, green: 0, blue: 0, alpha: 1),
        UIColor(red: 255/255, green: 0, blue: 0, alpha: 1),
        UIColor(red: 162/255, green: 192/255, blue: 55/255, alpha: 1),
        UIColor(red: 40/255, green: 149/255, blue: 72/255, alpha: 1),
        UIColor(red: 0/255, green: 157/255, blue: 224/255, alpha: 1),
        UIColor(red: 56/255, green: 89/255, blue: 132/255, alpha: 1),
        UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1),
        UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1),
        UIColor(red: 231/255, green: 177/255, blue: 66/255, alpha: 1),
        UIColor(red: 205/255, green: 91/255, blue: 28/255, alpha: 1),
        UIColor(red: 90/255, green: 40/255, blue: 127/255, alpha: 1),
        UIColor(red: 196/255, green: 0/255, blue: 122/255, alpha: 1),
        UIColor(red: 224/255, green: 104/255, blue: 150/255, alpha: 1),
        UIColor(red: 255/255, green: 237/255, blue: 0/255, alpha: 1),
        UIColor(red: 114/255, green: 79/255, blue: 43/255, alpha: 1)
    ];
    
    var colorsText = [
        NSLocalizedString("White", comment: "White"),
        NSLocalizedString("Black", comment: "Black"),
        NSLocalizedString("Red", comment: "Red"),
        NSLocalizedString("Light Green", comment: "Light Green"),
        NSLocalizedString("Dark Green", comment: "Dark Green"),
        NSLocalizedString("Light Blue", comment: "Light Blue"),
        NSLocalizedString("Dark Blue", comment: "Dark Blue"),
        NSLocalizedString("Light Gray", comment: "Light Gray"),
        NSLocalizedString("Dark Gray", comment: "Dark Gray"),
        NSLocalizedString("Light Orange", comment: "Light Orange"),
        NSLocalizedString("Dark Orange", comment: "Dark Orange"),
        NSLocalizedString("Violet", comment: "Violet"),
        NSLocalizedString("Magenta", comment: "Magenta"),
        NSLocalizedString("Pink", comment: "Pink"),
        NSLocalizedString("Yellow", comment: "Yellow"),
        NSLocalizedString("Brown", comment: "Brown")];

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);
        
        picker.tag = 0;
        pickerColor.tag = 1;
        
        if (currentColor == "0") {
            btnColor.hidden = true;
        }
        else {
            pickerColor.dataSource = self
            pickerColor.delegate = self
        }
        if (currentTalla == "0") {
            btnSize.hidden = true;
        }
        else {
            sizes = currentTalla.componentsSeparatedByString(",");
            picker.dataSource = self
            picker.delegate = self
        }

        image.image = UIImage(named: currentProduct);
        image.image = image.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image.tintColor = UIColor(white: 1, alpha: 1);
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
    @IBAction func selectSize(sender: UIButton) {
        picker.hidden = false;
    }

    @IBAction func selectColor(sender: UIButton) {
        pickerColor.hidden = false;
    }
    
    // MARK: - Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return sizes.count;
        }
        else {
            return colors.count;
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var pickerLabel = view as! UILabel!

        if (pickerView.tag == 0) {
            if view == nil {  //if no label there yet
                pickerLabel = UILabel()
            }
            let titleData:String = sizes[row] as! String
            let pickerFont = UIFont(name: "Bryant-MediumCondensed", size: 20) ?? UIFont.systemFontOfSize(20);
            
            let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle;
            textStyle.alignment = NSTextAlignment.Center;
            
            let myTitle = NSAttributedString(
                string: titleData,
                attributes: [
                    NSFontAttributeName:pickerFont,
                    NSForegroundColorAttributeName:UIColor(red: 0.0/255.0, green: 79.0/255.0, blue: 142.0/255.0, alpha: 1.0),
                    NSParagraphStyleAttributeName:textStyle
                ]);
            
            //This way you can set text for your label.
            pickerLabel!.attributedText = myTitle
        }
        else {
            if view == nil {  //if no label there yet
                pickerLabel = UILabel()
            }
            pickerLabel.backgroundColor = colors[row];
            let titleData:String = colorsText[row]
            let pickerFont = UIFont(name: "Bryant-MediumCondensed", size: 20) ?? UIFont.systemFontOfSize(20);
            
            let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle;
            textStyle.alignment = NSTextAlignment.Center;

            let shadow = NSShadow()
            shadow.shadowColor = UIColor(red: 0.0/255.0, green: 79.0/255.0, blue: 142.0/255.0, alpha: 1);
            shadow.shadowOffset = CGSizeMake (1.0, 1.0);
            shadow.shadowBlurRadius = 1;
            
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:pickerFont,NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 255/255.0, blue: 255.0/255.0, alpha: 1.0), NSParagraphStyleAttributeName:textStyle, NSShadowAttributeName:shadow])
            
            //This way you can set text for your label.
            pickerLabel!.attributedText = myTitle
        }
        
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            picker.hidden = true;
            tallaSeleccionada = (sizes[row] as? String)!;
            btnSize.setTitle(tallaSeleccionada, forState: UIControlState.Normal);
        }
        else {
            pickerColor.hidden = true;
            colorSeleccionado = colors[row];
            image.tintColor = colorSeleccionado;
            textColorSelecciondo = colorsText[row];
            btnColor.setTitle(textColorSelecciondo, forState: UIControlState.Normal);
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "finalProduct" {
            var producto = segue.destinationViewController as! FinalProductViewController;
            
            producto.nombre = self.title;
            producto.producto = currentProduct;
            producto.talla = tallaSeleccionada;
            producto.textColor = textColorSelecciondo;
            producto.color = colorSeleccionado;

        }
    }


}
