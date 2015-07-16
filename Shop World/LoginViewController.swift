//
//  LoginViewController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 30/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var persiana: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);
        
        let locale: NSLocale = NSLocale.currentLocale();
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        let currencyCode = locale.objectForKey(NSLocaleCurrencyCode) as! String;
        let languageCode = locale.objectForKey(NSLocaleLanguageCode) as! String;

        var country: String = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)!
        var currency: String = locale.displayNameForKey(NSLocaleCurrencyCode, value: currencyCode)!
        var language: String = locale.displayNameForKey(NSLocaleLanguageCode, value: languageCode)!
        
//        println("\(country) : \(countryCode)");
//        println("\(currency) : \(currencyCode)");
//        println("\(language) : \(languageCode)");
        
        let localStorage = NSUserDefaults.standardUserDefaults();
        
        if let id_usuario = localStorage.stringForKey("id_usuario"){
            let inicio = self.storyboard?.instantiateViewControllerWithIdentifier("inicio") as! TabBarController;
            self.presentViewController(inicio, animated: true, completion: nil);
        }

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
